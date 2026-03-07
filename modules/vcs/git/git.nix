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
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Niakr1s";
        email = "pavel2188@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };
}
