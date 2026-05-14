{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = [
      "gemma4:e4b"
      "qwen3.5:9b"
    ];
  };
}
