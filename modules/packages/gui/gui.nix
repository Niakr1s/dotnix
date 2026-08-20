{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.modules.packages.gui;
  gpu = config.modules.core.gpu;
  user = config.modules.core.user;

  handbrakePkg =
    if gpu.nvidia.enable
    then
      (pkgs.handbrake.overrideAttrs (previous: {
        nativeBuildInputs = (previous.nativeBuildInputs or []) ++ [pkgs.autoAddDriverRunpath];
      }))
    else pkgs.handbrake;
in {
  config = mkIf cfg.enable {
    services.crossmacro = {
      enable = true;
      users = ["${user}"];
    };

    environment.systemPackages = with pkgs; [
      # Browser
      firefox
      tor-browser # For onion websites

      # Internet
      qbittorrent
      telegram-desktop # Messaging app
      remmina # Remote Desktop client (supports RDP, VNC, etc)

      # Video
      mpv
      losslesscut-bin
      kdePackages.kdenlive # Video editing
      handbrakePkg # Open-source video transcoder

      # Audio
      strawberry
      audacity # Audio editing
      tageditor # Audio tags editor

      # Graphics & CAD
      librecad # autocad for poor
      conjure # ImageMagick GUI
      inkscape # Vector graphics editor
      gimp # Professional image editor
      krita # image editor
      xnconvert # bulk image converter
      nomacs # good image viewer

      # Office & Productivity
      obsidian
      libreoffice
      sqlitestudio
      foliate

      # Hardware & System Monitor
      cpu-x
      hardinfo2
      gpu-viewer
      furmark # GPU stress test (verify package name)

      # Secrets
      keepassxc

      # System Utilities & Configuration
      ripdrag
      gprename # GUI bulk rename tool
      bulky # GUI bulk rename tool
      dconf-editor # GSettings configuration editor

      # Development & Scripting GUIs
      zenity # GTK dialog boxes for scripts
      yad # Yet Another Dialog (GTK/Qt)

      # Gaming & Streaming
      moonlight-qt
    ];

    # appimage support
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
