{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    claude-code-bin
    opencode
  ];

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = [
      "gemma4:e4b"
      "qwen3.5:9b"
      "qwen3-embedding:8b"
    ];
  };
}
