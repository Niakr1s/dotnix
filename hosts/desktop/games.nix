{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  hostname,
  username,
  home-manager,
  ...
}: let
  unstablePkgs = import nixpkgs-unstable {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };
in {
  imports = [
    ../../modules/gaming/retroarch/retroarch.nix
  ];

  environment.systemPackages = with pkgs; [
    openttd # clone of "Transport Tycoon Deluxe"
    zeroad # 0ad
    wesnoth # turn based strategy
    widelands # settlers
  ];
}
