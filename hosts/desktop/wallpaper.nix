{
  config,
  lib,
  pkgs,
  inputs,
  home-manager,
  nixpkgs-unstable,
  stateVersion,
  hostname,
  username,
  ...
}: let
in {
  home-manager.users.${username} = {
    # Wallpaper
    xdg.configFile.".wallpaper".source = pkgs.fetchurl {
      # Set desired wallpaper url here
      url = "https://w.wallhaven.cc/full/o5/wallhaven-o5k319.jpg";
      # and after nixos error - copy paste it's sha256 here
      sha256 = "sha256-QcKntDg+YYSRxtwQeA+rahXGwxktcPwvyMy5GJoiNec=";
    };
  };
}
