{
  config,
  lib,
  flakeLib,
  ...
}:
let
  cfg = config.modules.services.comfyui;
  user = config.modules.core.user;
  gpu = config.modules.core.gpu;

  port = 8188;
in
{
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.comfyui = {
          enable = true;

          createUser = false;
          user = user;
          group = "users";
          dataDir = "/home/${user}/.comfyui";

          gpuSupport =
            if gpu.nvidia.enable then
              "cuda"
            else if gpu.amd.enable then
              "rocm"
            else
              null; # Skips/omits the configuration if both are disabled
          cudaCapabilities = lib.mkIf gpu.nvidia.enable [ "8.9" ]; # Optional: optimize system CUDA packages for RTX 40xx

          enableManager = true; # Enable the built-in ComfyUI Manager
          port = port;
          listenAddress = "127.0.0.1"; # Use "0.0.0.0" for network access
          openFirewall = false;
          # extraArgs = [ "--lowvram" ];
          # environment = { };
        };
        systemd.services.comfyui.wantedBy = lib.mkForce [ ];
      }
      (flakeLib.localhostReverseProxy "comfyui" port { })
    ]
  );
}
