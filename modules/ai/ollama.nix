{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = [
      "gemma3:12b"
      "qwen2.5-coder:7b"
      "qwen2.5-coder:14b"
    ];
  };
}
