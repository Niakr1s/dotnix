{
  inputs,
  config,
  lib,
  pkgs,
  hostname,
  unstablePkgs,
  username,
  ...
}: {
  imports = [
    ./extensions/gsconnect.nix
    ./extensions/app-grid-wizard.nix
  ];

  services.desktopManager.gnome.enable = true;

  services.gnome.core-apps.enable = true;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome-clocks
    #gnome-control-center
    gnome-initial-setup
    gnome-music
    #gnome-connections
    gnome-contacts
    gnome-tour
    #snapshot
    cheese
    epiphany
    evince
    geary
    totem
    yelp
    snapshot
    showtime
  ];
}
