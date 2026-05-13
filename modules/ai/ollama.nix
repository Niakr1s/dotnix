{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = [
      "gemma4:e4b"
      "qwen2.5-coder:7b"
      "qwen2.5-coder:14b"
      "qwen3.5:9b"
    ];
  };
}
