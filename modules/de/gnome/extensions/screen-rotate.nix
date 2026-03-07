{
  inputs,
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  hostname,
  username,
  stateVersion,
  home-manager,
  ...
}: let
in {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      gnomeExtensions.screen-rotate
    ];
    dconf = {
      settings = with lib.hm.gvariant; {
        "org/gnome/shell" = {
          enabled-extensions = [
            pkgs.gnomeExtensions.screen-rotate.extensionUuid
          ];
        };
        "org/gnome/shell/extensions/screen-rotate" = {
          manual-flip = true;
        };
      };
    };
  };
}
