{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.packages.gui.zed;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zed-editor
      mcp-nixos
    ];
  };
}
