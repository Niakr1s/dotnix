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
      gnomeExtensions.blur-my-shell
    ];
    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.blur-my-shell.extensionUuid
        ];
      };
      # Configure individual extensions
      "org/gnome/shell/extensions/blur-my-shell" = {
        brightness = 0.75;
        noise-amount = 0;
      };
      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        enable-all = true;
        blur = true;
        blacklist = [
          "Plank"
          "com.desktop.ding"
          "Conky"
        ];
      };
    };
  };
}
