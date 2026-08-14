{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.packages.gaming.emulators.sony-ps4;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      shadps4-qtlauncher
    ];
  };
}
