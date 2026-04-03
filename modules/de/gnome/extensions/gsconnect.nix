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
      gnomeExtensions.gsconnect
    ];
    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.gsconnect.extensionUuid
        ];
      };
    };
  };
}
