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
    weechat
  ];

  home-manager.users.${username} = {config, ...}: {
    xdg.configFile."weechat" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/weechat";
      recursive = true;
    };
  };
}
