{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  hostname,
  username,
  home-manager,
  ...
}: let
in {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      gnomeExtensions.app-grid-wizard
    ];
    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.app-grid-wizard.extensionUuid
        ];
      };
    };
  };
}
