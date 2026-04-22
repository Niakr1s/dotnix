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
  environment.systemPackages = with pkgs; [
    retroarch-full # retroarch

    openttd # clone of "Transport Tycoon Deluxe"
    zeroad # 0ad
    wesnoth # turn based strategy
    widelands # settlers
  ];
}
