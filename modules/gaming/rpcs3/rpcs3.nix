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
    rpcs3
  ];

  home-manager.users.${username} = {config, ...}: {
    home.file.".config/rpcs3/config.yml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/rpcs3/config.yml";
    };
    home.file.".config/rpcs3/custom_configs" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/rpcs3/custom_configs";
    };
  };
}
