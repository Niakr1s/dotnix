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
    xdg.configFile."celluloid" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/mpv";
      recursive = true;
    };

    home.packages = with pkgs; [celluloid];

    dconf.settings = {
      "io/github/celluloid-player/celluloid" = {
        mpv-input-config-enable = false; # it won't work with touchpad, so I don't need it
        mpv-input-config-file = "file:///home/${username}/.config/mpv/input.conf";
        mpv-config-enable = true;
        mpv-config-file = "file:///home/${username}/.config/mpv/mpv.conf";
        csd-enable = true;
      };
    };
  };
}
