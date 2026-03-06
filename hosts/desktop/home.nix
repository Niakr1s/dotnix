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
    ../../modules/home/dconf/dconf.multiple.monitors.nix
    ../../modules/home/gnome/extensions/blur-my-shell.nix
  ];

  # lutris
  programs.lutris = with pkgs; {
    enable = true;
    defaultWinePackage = proton-ge-bin;
    extraPackages = [
      winetricks
      gamescope
      gamemode
      umu-launcher
    ];
    protonPackages = [
      proton-ge-bin
    ];
    winePackages = [
      proton-ge-bin
      # wineWow64Packages.waylandFull # native wayland support (unstable)
    ];
    runners = {
      wine = {
        settings = {
          system = {
            env = {
              PROTON_ENABLE_HDR = 1;
              PROTON_ENABLE_WAYLAND = 1;
            };
            gamescope = false;
            gamescope_hdr = false;
            mangohud = true;
          };
        };
      };
    };
  };
}
