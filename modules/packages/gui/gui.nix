{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf ;

  cfg = config.modules.features.graphicalPkgs;
  user = config.modules.core.user;
in
{
  config = mkIf cfg.enable {
    nixpkgs.config.permittedInsecurePackages = [
      "electron-40.10.5"
    ];

    services.crossmacro = {
      enable = true;
      users = [ "${user}" ];
    };

    environment.systemPackages =
      with pkgs;
      [
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
        (handbrake.overrideAttrs (previous: {
          nativeBuildInputs = (previous.nativeBuildInputs or [ ]) ++ [ pkgs.autoAddDriverRunpath ];
        }))
        obs-studio
        clementine
        playerctl
        qbittorrent
        gpu-viewer
        losslesscut-bin
        strawberry
        moonlight-qt
        winboat # TODO: probably move to services
      ];
  };
}
