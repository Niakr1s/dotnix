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
  unstablePkgs = import nixpkgs-unstable {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };
in {
  imports = [
    ../default/home.nix
    ./wallpaper.nix # You can change wallpaper in this file
  ];
  home.packages = with pkgs; [
    gnomeExtensions.gjs-osk
  ];
  dconf = {
    enable = true;
    settings = with lib.hm.gvariant; {
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.screen-rotate.extensionUuid
          pkgs.gnomeExtensions.gjs-osk.extensionUuid
        ];
      };
      "org/gnome/shell/extensions/screen-rotate" = {
        manual-flip = true;
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
