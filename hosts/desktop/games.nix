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
    zeroad # 0ad
    superTux # mario like
    superTuxKart # mariokart like
    hedgewars # червячки
    openttd # clone of "Transport Tycoon Deluxe"
    wesnoth # turn based strategy
    widelands # settlers
    endless-sky # space trader
  ];
}
