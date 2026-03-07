{
  inputs,
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  hostname,
  username,
  home-manager,
  ...
}: let
in {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      gnomeExtensions.display-configuration-switcher
    ];
    dconf = {
      settings = with lib.hm.gvariant; {
        "org/gnome/shell" = {
          enabled-extensions = [
            pkgs.gnomeExtensions.display-configuration-switcher.extensionUuid
          ];
        };
        "org/gnome/shell/extensions/display-configuration-switcher" = {
          display-configuration-switcher-shortcut-next = ["<Alt><Super>p"];
          display-configuration-switcher-shortcut-previous = [];
          display-configuration-switcher-shortcuts-enabled = true;
        };
      };
    };
  };
}
