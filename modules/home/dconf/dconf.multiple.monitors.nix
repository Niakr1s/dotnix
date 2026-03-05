### This config should be included if a machine has multiple displays
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
  dconf = {
    enable = true;
    settings = with lib.hm.gvariant; {
      ### Keybindings for two monitors
      "org/gnome/desktop/wm/keybindings" = {
        # Move to monitors
        move-to-monitor-down = [];
        move-to-monitor-up = [];
        move-to-monitor-left = lib.mkForce ["<Alt><Super>bracketleft"];
        move-to-monitor-right = lib.mkForce ["<Alt><Super>bracketright"];
      };

      ### Display configuration switcher

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
}
