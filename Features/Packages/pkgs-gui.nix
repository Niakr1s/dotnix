{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  inherit (types) bool;

  cfg = config.features.graphicalPkgs;
  user = config.core.user;
  headless = config.core.headless;
in
{
  options.features.graphicalPkgs = {
    enable = mkOption {
      type = bool;
      default = !headless;
      description = "Graphical Packages";
    };
  };

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
