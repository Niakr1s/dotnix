{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.packages.gui.winboat;
in
{
  config = lib.mkIf cfg.enable {
    nixpkgs.config.permittedInsecurePackages = [
      "electron-40.10.5"
    ];

    environment.systemPackages = with pkgs; [
      winboat
    ];
  };
}
