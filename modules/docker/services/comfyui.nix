# https://hub.docker.com/r/yanwk/comfyui-boot
{
  pkgs,
  username,
  ...
}: let
  # Docker image configuration
  dockerImage = "yanwk/comfyui-boot:cu130-megapak-pt211@sha256:7d6f3a3510930b598ef8f753b755cc7d59be45793d4f4d042c5c123e6e006ff9";
  containerName = "comfyui-cu130";

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

  # Extract just host directories for mkdir
  hostDirs = map (m: m.host) mappings;

  # Create mkdir command
  mkdirCommand = "${pkgs.coreutils}/bin/mkdir -p ${builtins.concatStringsSep " " hostDirs}";

  # Create volume flags for docker
  volumeFlags = builtins.concatStringsSep " " (map (m: "-v ${m.host}:${m.container}") mappings);

  dockerRun = ''
    ${pkgs.docker}/bin/docker run -d \
      --name ${containerName} \
      --device nvidia.com/gpu=all \
      -p 8188:8188 \
      ${volumeFlags} \
      -e CLI_ARGS="" \
      ${dockerImage}
  '';
in {
  systemd.user.services.comfyui = {
    description = "ComfyUI Docker Container";
    after = ["docker.service"];
    wantedBy = ["default.target"];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = [
        mkdirCommand
        "${pkgs.docker}/bin/docker pull ${dockerImage}"
      ];
      ExecStart = "${dockerRun}";
      ExecStop = "${pkgs.docker}/bin/docker stop ${containerName}";
      ExecStopPost = "${pkgs.docker}/bin/docker rm ${containerName}";
    };
  };
}
