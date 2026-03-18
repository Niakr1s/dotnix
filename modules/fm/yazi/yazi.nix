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

    home.file.".config/yazi/keymap.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/yazi/keymap.toml";
    };

    programs.yazi = {
      enable = true;
      plugins = {
        inherit (pkgs.yaziPlugins) mediainfo;
        inherit (pkgs.yaziPlugins) bookmarks;
      };
    };
  };
}
