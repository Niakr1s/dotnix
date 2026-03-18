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
  home-manager.users.${username} = {config, ...}: {
    home.file.".config/yazi/yazi.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/yazi/yazi.toml";
    };

    programs.yazi = {
      enable = true;
      plugins = {
        inherit (pkgs.yaziPlugins) mediainfo;
      };
    };
  };
}
