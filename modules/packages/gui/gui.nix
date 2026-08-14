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
      playerctl
      qbittorrent
      gpu-viewer
      losslesscut-bin
      strawberry
      moonlight-qt
      sqlitestudio
      kdePackages.kdenlive # Video editing
      audacity # Audio editing
      tageditor # Audio tags editor
      conjure # ImageMagick GUI
      inkscape # Vector graphics editor
      gimp # Professional image editor
      telegram-desktop # Messaging app
      remmina # Remote Desktop client (supports RDP, VNC, etc)
      tor-browser # For onion websites
      gprename # GUI bulk rename tool
      bulky # GUI bulk rename tool
      furmark # GPU stress test (verify package name)
      zenity # GTK dialog boxes for scripts
      yad # Yet Another Dialog (GTK/Qt)
      dconf-editor # GSettings configuration editor
    ];
  };
}
