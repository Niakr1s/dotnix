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
  home-manager,
  ...
}: let
in {
  home-manager.users.${username} = {
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
      };
    };
  };
}
