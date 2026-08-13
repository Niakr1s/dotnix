{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkIf concatStringsSep optionals;
  cfg = config.features.ai.llama;
  gpu = config.core.gpu;

  llama-cpp = pkgs.llama-cpp.override {
    cudaSupport = gpu.nvidia;
    rocmSupport = gpu.amd;
  };
  llama-server = lib.getExe' llama-cpp "llama-server";

  sd-cpp = pkgs.stable-diffusion-cpp.override {
    cudaSupport = gpu.nvidia;
    rocmSupport = gpu.amd;
  };
  sd-server = lib.getExe' sd-cpp "sd-server";

  # Build an sd-server command for SDXL models.
  mkSD =
    {
      model,
      checkEndpoint ? "/",
    }:
    {
      cmd = concatStringsSep " " [
        sd-server
        "--listen-port \${PORT}"
        "--diffusion-fa"
        "--vae-tiling"
        "-m"
        model
      ];
      checkEndpoint = checkEndpoint;
    };

  # Common flags parsed from [*] section
  globalFlags = concatStringsSep " " [
    "--port \${PORT}"
    "--jinja"
    "--parallel 1"
    "--flash-attn on"
    "--no-mmproj-offload"
    "--cache-type-k q8_0"
    "--cache-type-v q8_0"
    "--n-gpu-layers 999"
    "--split-mode layer"
    "--ctx-size 200000"
  ];

  # Build an llama-server command. Only `model` is required;
  # every other flag is optional and only emitted when set.
  mkLlmCmd =
    {
      model,
      tensorSplit ? null,
      temperature ? null,
      topK ? null,
      topP ? null,
      minP ? null,
      presencePenalty ? null,
      repeatPenalty ? null,
      mmproj ? null,
      imageMinTokens ? null,
    }:
    concatStringsSep " " (
      [
        llama-server
        globalFlags
        "--model"
        model
      ]
      ++ optionals (tensorSplit != null) [ "--tensor-split" tensorSplit ]
      ++ optionals (temperature != null) [ "--temperature" temperature ]
      ++ optionals (topK != null) [ "--top-k" topK ]
      ++ optionals (topP != null) [ "--top-p" topP ]
      ++ optionals (minP != null) [ "--min-p" minP ]
      ++ optionals (presencePenalty != null) [ "--presence-penalty" presencePenalty ]
      ++ optionals (repeatPenalty != null) [ "--repeat-penalty" repeatPenalty ]
      ++ optionals (mmproj != null) [ "--mmproj" mmproj ]
      ++ optionals (imageMinTokens != null) [ "--image-min-tokens" imageMinTokens ]
    );
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = [ llama-cpp sd-cpp ];

    services.llama-swap = mkIf cfg.enable {
      enable = true;
      port = 8080;

      settings = {
        clientTimeout = 600;
        healthCheckTimeout = 60;

        models = {
          "Gemma4-26B-A4B-Uncensored" = {
            cmd = mkLlmCmd {
              model = "/data/ssd/models/LLM/HauhauCS/Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-MTP/Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-Q4_K_M.gguf";
              mmproj = "/data/ssd/models/LLM/HauhauCS/Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-MTP/mmproj-Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-BF16.gguf";
              tensorSplit = "0,4";
              temperature = "0.6";
              topK = "64";
              topP = "0.9";
              minP = "0.05";
              repeatPenalty = "1.1";
            };
          };

          "Qwen3.6-27B" = {
            cmd = mkLlmCmd {
              model = "/data/ssd/models/LLM/bartowski/Qwen_Qwen3.6-27B-GGUF/Qwen_Qwen3.6-27B-Q4_K_M.gguf";
              mmproj = "/data/ssd/models/LLM/bartowski/Qwen_Qwen3.6-27B-GGUF/mmproj-Qwen_Qwen3.6-27B-bf16.gguf";
              tensorSplit = "1,3";
              temperature = "0.6";
              topP = "0.95";
              topK = "20";
              minP = "0.0";
              presencePenalty = "0.0";
              repeatPenalty = "1.0";
              imageMinTokens = "1024";
            };
          };

          "Qwen3.6-35B-A3B" = {
            cmd = mkLlmCmd {
              model = "/data/ssd/models/LLM/bartowski/Qwen_Qwen3.6-35B-A3B-GGUF/Qwen_Qwen3.6-35B-A3B-Q4_K_M.gguf";
              mmproj = "/data/ssd/models/LLM/bartowski/Qwen_Qwen3.6-35B-A3B-GGUF/mmproj-Qwen_Qwen3.6-35B-A3B-bf16.gguf";
              tensorSplit = "1,4";
              temperature = "0.6";
              topP = "0.95";
              topK = "20";
              minP = "0.0";
              presencePenalty = "0.0";
              repeatPenalty = "1.0";
              imageMinTokens = "1024";
            };
          };

          "animosity_illustriousV11" = mkSD {
            model = "/data/ssd/models/checkpoints/animosity_illustriousV11.safetensors";
          };
        };
      };
    };
  };
}
