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
    ../../modules/editors/vscode/vscode.nix
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    kdePackages.kdenlive

    ## Opensource Games
    zeroad # 0ad
    superTux # mario like
    superTuxKart # mariokart like
    hedgewars # червячки
    chromium-bsu # top scroller space shooter
    crawlTiles # roguelike
    luanti # minecraft
    openttd # clone of "Transport Tycoon Deluxe"
    freeciv # civilization
    wesnoth # turn based strategy
    widelands # settlers
    endless-sky # space trader
    simutrans # transport simulator
    mindustry # TD
    vvvvvv # platform game
    openxcom # xcom
    ultrastardx # karaoke game
  ];

  # Home packages
  home-manager.users.${username} = {
    home.packages = with pkgs; [
    ];
  };
}
