{
  config,
  lib,
  flakeLib,
  ...
}: let
  user = config.modules.core.user;
  cfg = config.modules.services.comfyui;
  gpu = config.modules.core.gpu;

  # Docker image configuration
  dockerImage = "yanwk/comfyui-boot:cu130-slim-v2-20260814";

  # Base directories
  baseDir = "/home/${user}/.comfyui";

  # Single source of truth for all mappings
  # Format: { host = "path"; container = "path"; }
  mappings = [
    # images
    {
      host = "/home/${user}/Pictures/comfy/input";
      container = "/root/ComfyUI/input";
    }
    {
      host = "/home/${user}/Pictures/comfy/output";
      container = "/root/ComfyUI/output";
    }

    # cache
    {
      host = "${baseDir}/cache/dot-cache";
      container = "/root/.cache";
    }
    {
      host = "${baseDir}/cache/dot-config";
      container = "/root/.config";
    }

    # custom nodes
    {
      host = "${baseDir}/custom_nodes";
      container = "/root/ComfyUI/custom_nodes";
    }

    # models
    {
      host = "${baseDir}/models/models";
      container = "/root/ComfyUI/models";
    }
    {
      host = "${baseDir}/models/hf-hub";
      container = "/root/.cache/huggingface/hub";
    }
    {
      host = "${baseDir}/models/torch-hub";
      container = "/root/.cache/torch/hub";
    }

    # user
    {
      host = "${baseDir}/user";
      container = "/root/ComfyUI/user";
    }
  ];

  port = 8188;
in {
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        virtualisation.oci-containers.containers.comfyui = {
          image = "${dockerImage}";
          autoStart = false;
          podman.user = "${user}";

          volumes = map (m: "${m.host}:${m.container}") mappings;
          devices = lib.mkIf gpu.nvidia.enable ["nvidia.com/gpu=all"];

          extraOptions = ["--network=host"];
          # ports = [ "${toString port}:${toString port}" ];
        };

        networking.firewall = {
          allowedTCPPorts = [
            port
          ];
        };
      }
      (flakeLib.createUserDirs {
        dirs = map (m: "${m.host}") mappings;
        user = "${user}";
      })
      (flakeLib.localhostReverseProxy "comfyui" port {})
    ]
  );
}
