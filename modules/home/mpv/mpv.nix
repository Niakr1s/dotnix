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
  xdg.configFile."mpv" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotnix/config/mpv";
    recursive = true;
  };

  programs.mpv = {
    enable = true;
    package = (
      pkgs.mpv-unwrapped.wrapper {
        scripts = with pkgs.mpvScripts; [
          modernz
          autosub
          thumbfast
        ];

        mpv = pkgs.mpv-unwrapped.override {
          waylandSupport = true;
          ffmpeg = pkgs.ffmpeg-full;
        };
      }
    );
  };
}
