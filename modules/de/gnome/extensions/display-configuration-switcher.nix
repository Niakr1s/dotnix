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
  home.packages = with pkgs; [
    gnomeExtensions.display-configuration-switcher
  ];

  home-manager.users.${username} = {
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
