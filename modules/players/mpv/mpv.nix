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
  home-manager.users.${username} = {
    xdg.configFile."mpv" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotnix/config/celluloid";
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
