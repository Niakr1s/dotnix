{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  hostname,
  username,
  home-manager,
  flakeDir,
  ...
}: let
in {
  environment.systemPackages = with pkgs; [
    retroarch-full
  ];

  home-manager.users.${username} = {config, ...}: {
    home.file.".config/retroarch/retroarch.cfg" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/retroarch/retroarch.cfg";
    };
  };
}
