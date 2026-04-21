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
    ## Chess
    gnome-chess # chess
    stockfish # AI for chess

    ## Casual games
    ltris # tetris
    pokerth # poker
    pysolfc # soilitaire
    gnome-mines # minesweeper
    gnome-sudoku # sudoku
    gnome-2048 # 2048
    superTux # mario like
    superTuxKart # mariokart like
    hedgewars # червячки
    brogue-ce # roguelike
    endless-sky # space trader
    xmoto # elastomania
  ];
}
