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
  prodKeysFile = "prod.v21.2.0.keys";
in {
  environment.systemPackages = with pkgs; [
    ryubing
    nsz
  ];

  home-manager.users.${username} = {config, ...}: {
    # for nsz
    home.file.".switch/prod.keys" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/Ryujinx/system/${prodKeysFile}";
    };

    home.file.".config/Ryujinx/system/prod.keys" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/Ryujinx/system/${prodKeysFile}";
    };
    home.file.".config/Ryujinx/Config.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/Ryujinx/Config.json";
    };
  };
}
