{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = ["gemma3:12b"];
  };
}
