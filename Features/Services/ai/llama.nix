{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkIf
    ;
  cfg = config.features.ai.llama;
  gpu = config.core.gpu;

  # Compile llama-cpp with CUDA support for your Nvidia cards
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

  # Global flags parsed from your [*] section, split cleanly for scannability
  globalFlags = toString [
    "--port \${PORT}"
    "--jinja"
    "--parallel 1"
    "--flash-attn on"
    "--no-mmproj-offload"
    "--cache-type-k q8_0"
    "--cache-type-v q8_0"
    "--n-gpu-layers 999"
    "--split-mode layer"
    "--ctx-size 230000"
  ];
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = [
      llama-cpp
      sd-cpp
    ];

    services.llama-swap = mkIf cfg.enable {
      enable = true;
      port = 8080;

      settings = {
        clientTimeout = 600;
        healthCheckTimeout = 60;

        models = {
          "Gemma4-26B-A4B-Uncensored" = {
            cmd = ''
              ${llama-server} ${globalFlags} \
                --tensor-split 0,4 \
                --temperature 0.6 \
                --top-k 64 \
                --top-p 0.9 \
                --min-p 0.05 \
                --repeat-penalty 1.1 \
                --model /data/ssd/models/HauhauCS/Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-MTP/Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-Q4_K_M.gguf \
                --mmproj /data/ssd/models/HauhauCS/Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-MTP/mmproj-Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-BF16.gguf
            '';
          };

          "Qwen3.6-27B" = {
            cmd = ''
              ${llama-server} ${globalFlags} \
                --tensor-split 1,3 \
                --image-min-tokens 1024 \
                --temperature 0.6 \
                --top-p 0.95 \
                --top-k 20 \
                --min-p 0.0 \
                --presence-penalty 0.0 \
                --repeat-penalty 1.0 \
                --model /data/ssd/models/bartowski/Qwen_Qwen3.6-27B-GGUF/Qwen_Qwen3.6-27B-Q4_K_M.gguf \
                --mmproj /data/ssd/models/bartowski/Qwen_Qwen3.6-27B-GGUF/mmproj-Qwen_Qwen3.6-27B-bf16.gguf
            '';
          };

          "Qwen3.6-35B-A3B" = {
            cmd = ''
              ${llama-server} ${globalFlags} \
                --tensor-split 1,4 \
                --image-min-tokens 1024 \
                --temperature 0.6 \
                --top-p 0.95 \
                --top-k 20 \
                --min-p 0.0 \
                --presence-penalty 0.0 \
                --repeat-penalty 1.0 \
                --model /data/ssd/models/bartowski/Qwen_Qwen3.6-35B-A3B-GGUF/Qwen_Qwen3.6-35B-A3B-Q4_K_M.gguf \
                --mmproj /data/ssd/models/bartowski/Qwen_Qwen3.6-35B-A3B-GGUF/mmproj-Qwen_Qwen3.6-35B-A3B-bf16.gguf
            '';
          };

          "animosity_illustriousV11" = {
            cmd = ''
              ${sd-server} \
                --listen-port ''${PORT} \
                --diffusion-fa \
                --vae-tiling \
                -m /data/ssd/comfy/models/checkpoints/animosity_illustriousV11.safetensors
            '';
            checkEndpoint = "/";
          };
        };
      };
    };
  };
}
