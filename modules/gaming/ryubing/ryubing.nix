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
}: {
  environment.systemPackages = with pkgs; [
    ryubing
    nsz
  ];

  home-manager.users.${username} = {config, ...}: {
    home.file.".config/Ryujinx/system/prod.keys" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.switch/prod.keys";
    };
    home.file.".config/Ryujinx/Config.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/Ryujinx/Config.json";
    };
    home.file.".switch/prod.keys" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.switch/prod.keys";
    };
  };
}
