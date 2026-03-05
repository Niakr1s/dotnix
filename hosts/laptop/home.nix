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
  dconf = {
    enable = true;
    settings = with lib.hm.gvariant; {
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.screen-rotate.extensionUuid
        ];
      };
    };
  };
}
