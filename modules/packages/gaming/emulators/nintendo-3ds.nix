{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.packages.gaming.emulators.nintendo-3ds;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      azahar
    ];
  };
}
