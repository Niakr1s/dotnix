{
  inputs,
  config,
  lib,
  pkgs,
  hostname,
  unstablePkgs,
  username,
  stateVersion,
  ...
}: {
  services.desktopManager.gnome.enable = true;

  services.gnome.core-apps.enable = true;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome-clocks
    #gnome-control-center
    gnome-initial-setup
    gnome-music
    #pkgs.gnome-connections
    pkgs.gnome-contacts
    pkgs.gnome-tour
    #pkgs.snapshot
    cheese
    epiphany
    evince
    geary
    totem
    yelp
    decibels
    snapshot
    showtime
  ];
  environment.systemPackages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
    gnomeExtensions.forge
  ];
}
