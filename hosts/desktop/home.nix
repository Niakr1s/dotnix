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
    ../../modules/home/aichat/aichat.nix
    ../../modules/home/mangohud/mangohud.nix
    ../../modules/home/lutris/lutris.nix
    ../../modules/home/dconf/dconf.multiple.monitors.nix
    ../../modules/home/gnome/extensions/blur-my-shell.nix
    ../../modules/home/gnome/extensions/display-configuration-switcher.nix
  ];
}
