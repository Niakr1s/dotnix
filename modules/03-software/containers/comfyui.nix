# https://hub.docker.com/r/yanwk/comfyui-boot
{
  flakeLib,
  username,
  ...
}:
let
  # Docker image configuration
  dockerImage = "yanwk/comfyui-boot:cu130-megapak-pt211@sha256:7d6f3a3510930b598ef8f753b755cc7d59be45793d4f4d042c5c123e6e006ff9";

  # Base directories
  baseDir = "/home/${username}/.comfyui";

  # Single source of truth for all mappings
  # Format: { host = "path"; container = "path"; }
  mappings = [
    {
      host = "${baseDir}/cache/dot-cache";
      container = "/root/.cache";
    }
    {
      host = "${baseDir}/cache/dot-config";
      container = "/root/.config";
    }
    {
      host = "${baseDir}/nodes/dot-local";
      container = "/root/.local";
    }
    {
      host = "${baseDir}/nodes/custom_nodes";
      container = "/root/ComfyUI/custom_nodes";
    }
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
    {
      host = "${baseDir}/user/input";
      container = "/root/ComfyUI/input";
    }
    {
      host = "${baseDir}/user/output";
      container = "/root/ComfyUI/output";
    }
    {
      host = "${baseDir}/user/user-profile";
      container = "/root/ComfyUI/user";
    }
    {
      host = "${baseDir}/user/user-scripts";
      container = "/root/user-scripts";
    }
  ];

  port = 8188;
in
{
  imports = [
    (flakeLib.localhostReverseProxy "comfyui" port)
    (flakeLib.createDirs {
      dirs = (map (m: "${m.host}") mappings);
      user = "${username}";
      group = "users";
    })
  ];

  virtualisation.oci-containers.containers.comfyui = {
    image = "${dockerImage}";
    autoStart = false;
    podman.user = "${username}";

    volumes = (map (m: "${m.host}:${m.container}") mappings);
    devices = [ "nvidia.com/gpu=all" ];
    ports = [ "${toString port}:${toString port}" ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      port
    ];
  };
}
