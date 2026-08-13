{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf ;

  cfg = config.features.graphicalPkgs;
  user = config.core.user;
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
      ]
      ++ lib.optionals (!config.core.isLaptop.enable) [
        winboat
      ]
      ++ lib.optionals (config.core.isLaptop.enable) [
        moonlight-qt
      ];
  };
}
