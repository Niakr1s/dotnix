{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.packages.gui.blender;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      blender
    ];
  };
}
