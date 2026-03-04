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
  unstablePkgs = import nixpkgs-unstable {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };
in {
  imports = [
    ../common/home.nix
    ./wallpaper.nix # You can change wallpaper in this file
  ];

  # HOME SYMLINKS

  xdg.configFile."MangoHud" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotnix/config/MangoHud";
    recursive = true;
  };

  # home.file."local/share/lutris/runners/wine.yml".source = config.lib.file.mkOutOfStoreSymlink "/path/to/your/wine.yml";

  dconf.settings = {
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
}
