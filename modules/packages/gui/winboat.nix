{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.packages.gui.winboat;
in {
  config = lib.mkIf cfg.enable {
    warnings = [
      ''
        after installing windows in winboat, you can add a shared directory in "/home/user/.winboat/podman-compose.yml" under "volumes":  /data:/shared2
                after that you need to do this manually: "docker compose down && docker compose up -d"''
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "electron-40.10.5"
    ];

    environment.systemPackages = with pkgs; [
      winboat
    ];
  };
}
