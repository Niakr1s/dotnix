{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  hostname,
  username,
  flakeDir,
  ...
}: let
in {
  home-manager.users.${username} = {config, ...}: {
    xdg.configFile."mpv" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/mpv";
      recursive = true;
    };

    programs.mpv = {
      enable = true;
      package = (
        pkgs.mpv-unwrapped.wrapper {
          scripts = with pkgs.mpvScripts; [
            modernz
          ];
          mpv = pkgs.mpv-unwrapped.override {
            waylandSupport = true;
            ffmpeg = pkgs.ffmpeg-full;
          };
        }
      );
    };
  };
}
