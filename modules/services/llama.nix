{
  config,
  pkgs,
  lib,
  flakeLib,
  ...
}: let
  inherit (lib) mkIf concatStringsSep optionals;
  cfg = config.modules.services.llama;

  port = 8080;

  # this is a auxillary script to generate images using llama-swap in batches
  imggenPkg = pkgs.writeShellApplication {
    name = "imggen";
    runtimeInputs = [
      pkgs.curl
      pkgs.jq
      pkgs.util-linux
      pkgs.chafa
    ];
    text = ''
      export PORT="${toString port}"
      exec ${./llama/imggen.sh} "$@"
    '';
  };

  llama-server = lib.getExe' pkgs.llama-cpp "llama-server";
  sd-server = lib.getExe' pkgs.stable-diffusion-cpp "sd-server";

  # Common flags parsed from [*] section
  llmCommonFlags = concatStringsSep " " [
    "--port \${PORT}"
    "--jinja"
    "--parallel 1"
    "--flash-attn on"
    "--no-mmproj-offload"
    "--cache-type-k q8_0"
    "--cache-type-v q8_0"
    "--n-gpu-layers 999"
    "--split-mode layer"
    "--ui-mcp-proxy"
  ];

  # Build an llama-server command. Only `model` is required;
  # every other flag is optional and only emitted when set.
  mkLlm = {
    model,
    ctxSize ? 230000,
    tensorSplit ? null,
    temperature ? null, # 0.1 - strict, 1.1 - imaginative
    topK ? null,
    topP ? null,
    minP ? null,
    presencePenalty ? null,
    repeatPenalty ? null,
    mmproj ? null,
    imageMinTokens ? null,
  }: {
    cmd = concatStringsSep " " (
      [
        llama-server
        llmCommonFlags
        "--model"
        model
        "--ctx-size"
        "${toString ctxSize}"
      ]
      ++ optionals (tensorSplit != null) [
        "--tensor-split"
        tensorSplit
      ]
      ++ optionals (temperature != null) [
        "--temperature"
        temperature
      ]
      ++ optionals (topK != null) [
        "--top-k"
        topK
      ]
      ++ optionals (topP != null) [
        "--top-p"
        topP
      ]
      ++ optionals (minP != null) [
        "--min-p"
        minP
      ]
      ++ optionals (presencePenalty != null) [
        "--presence-penalty"
        presencePenalty
      ]
      ++ optionals (repeatPenalty != null) [
        "--repeat-penalty"
        repeatPenalty
      ]
      ++ optionals (mmproj != null) [
        "--mmproj"
        mmproj
      ]
      ++ optionals (imageMinTokens != null) [
        "--image-min-tokens"
        imageMinTokens
      ]
    );
  };

  mkSD = {
    model ? null, # safetensors
    diffusion-model ? null, # gguf
    vae ? null,
    clip_l ? null,
    t5xxl ? null,
  }: {
    cmd = concatStringsSep " " (
      [
        sd-server
        "--listen-port \${PORT}"
        "--diffusion-fa"
        "--vae-tiling"
      ]
      ++ optionals (model != null) [
        "--model"
        model
      ]
      ++ optionals (diffusion-model != null) [
        "--diffusion-model"
        diffusion-model
      ]
      ++ optionals (vae != null) [
        "--vae"
        vae
      ]
      ++ optionals (clip_l != null) [
        "--clip_l"
        clip_l
      ]
      ++ optionals (t5xxl != null) [
        "--t5xxl"
        t5xxl
      ]
    );
    checkEndpoint = "/";
  };
in {
  config = mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = with pkgs; [
          llama-cpp
          stable-diffusion-cpp
          imggenPkg
        ];

        services.llama-swap = mkIf cfg.enable {
          enable = true;
          listenAddress = "0.0.0.0";
          port = port;

          settings = {
            clientTimeout = 600;
            healthCheckTimeout = 60;

            # groups documentation
            # swap: how members of this group swap among themselves
            # - optional, default: true
            # - true:  only one member runs at a time
            # - false: all members can run together, no swapping
            # exclusive: how this group affects other groups
            # - optional, default: true
            # - true:  running a member unloads every other group
            # - false: running a member leaves other groups untouched
            # persistent: other groups cannot unload this group's members
            # - optional, default: false
            # - has no effect on swapping within the group
            groups = {
              tiny = {
                swap = false;
                exclusive = true;
                members = [
                  "Gemma4-26B-A4B-Uncensored"
                ];
              };
              huge = {
                swap = true;
                exclusive = true;
                members = [
                  "Qwen3.6-27B"
                  "Qwen3.6-35B-A3B"
                ];
              };
            };

            models = {
              "Gemma4-26B-A4B-Uncensored" = mkLlm {
                ctxSize = 192000;
                model = "/data/ssd/models/LLM/HauhauCS/Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-MTP/Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-Q4_K_M.gguf";
                mmproj = "/data/ssd/models/LLM/HauhauCS/Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-MTP/mmproj-Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-BF16.gguf";
                tensorSplit = "0,4";
                temperature = "1.0";
                topK = "64";
                topP = "0.9";
                minP = "0.05";
                repeatPenalty = "1.1";
              };

              "Qwen3.6-27B" = mkLlm {
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

              "Qwen3.6-35B-A3B" = mkLlm {
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
          };
        };
      }
      (flakeLib.localhostReverseProxy "llama" port {})
    ]
  );
}
