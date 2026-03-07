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
    ../../modules/ai/aichat/aichat.nix
    ../../modules/gaming/mangohud/mangohud.nix
    ../../modules/dconf/dconf.multiple.monitors.nix
    ../../modules/de/gnome/extensions/blur-my-shell.nix
    ../../modules/de/gnome/extensions/display-configuration-switcher.nix
  ];
}
