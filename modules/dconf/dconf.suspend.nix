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
    dconf = {
      settings = with lib.hm.gvariant; {
        "org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-ac-type = lib.mkForce "suspend";
          sleep-inactive-ac-timeout = lib.mkForce "900"; # in seconds
          power-button-action = lib.mkForce "suspend";
        };
      };
    };
  };
}
