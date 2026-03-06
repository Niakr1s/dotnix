{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  stateVersion,
  hostname,
  username,
  ...
}: let
in {
  home.packages = with pkgs; [
    gnomeExtensions.gjs-osk
  ];
  dconf = {
    settings = with lib.hm.gvariant; {
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.gjs-osk.extensionUuid
        ];
      };
      "org/gnome/shell/extensions/gjsosk" = {
        enable-drag = true;
        indicator-enabled = true;

        # open upon clicking on text field
        # 0 = never, 1 = only on touch, 2 = always
        enable-tap-gesture = 0;

        # default position: bottom corner
        default-snap = 7;
      };
    };
  };
}
