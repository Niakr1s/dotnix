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
    gnome-chess # chess
    stockfish # AI for chess
    ltris # tetris
    pokerth # poker
    pysolfc # soilitaire
    gnome-mines # minesweeper
    gnome-sudoku # sudoku
    gnome-2048 # 2048

    brogue-ce # roguelike
    crawl # roguelike
  ];
}
