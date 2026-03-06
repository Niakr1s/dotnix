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
  xdg.configFile."celluloid" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotnix/config/celluloid";
    recursive = true;
  };

  home.packages = with pkgs; [celluloid];
}
