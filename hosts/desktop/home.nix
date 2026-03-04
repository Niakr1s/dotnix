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
    ../common/home.nix
  ];

  # Wallpaper
  xdg.configFile.".wallpaper".source = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/o5/wallhaven-o5k319.jpg";
    sha256 = "sha256-QcKntDg+YYSRxtwQeA+rahXGwxktcPwvyMy5GJoiNec=";
  };

  xdg.configFile."MangoHud" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotnix/config/MangoHud";
    recursive = true;
  };

  # home.file."local/share/lutris/runners/wine.yml".source = config.lib.file.mkOutOfStoreSymlink "/path/to/your/wine.yml";
}
