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
in {
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
