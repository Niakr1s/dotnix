{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.modules.packages.gui;
  gpu = config.modules.core.gpu;
  user = config.modules.core.user;

  handbrakePkg =
    if gpu.nvidia.enable then
      (pkgs.handbrake.overrideAttrs (previous: {
        nativeBuildInputs = (previous.nativeBuildInputs or [ ]) ++ [ pkgs.autoAddDriverRunpath ];
      }))
    else
      pkgs.handbrake;
in
{
  config = mkIf cfg.enable {
    services.crossmacro = {
      enable = true;
      users = [ "${user}" ];
    };

    environment.systemPackages = with pkgs; [
      mpv
      ripdrag
      obsidian
      firefox
      librecad
      libreoffice
      blender
      keepassxc
      cpu-x
      hardinfo2
      handbrakePkg
      obs-studio
      clementine
      playerctl
      qbittorrent
      gpu-viewer
      losslesscut-bin
      strawberry
      moonlight-qt
    ];
  };
}
