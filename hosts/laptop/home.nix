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
    # ../../modules/home/dconf/dconf.suspend.nix # turn on suspend for laptop
    ../../modules/home/gnome/extensions/screen-rotate.nix
    ../../modules/home/gnome/extensions/gjs-osk.nix
  ];
}
