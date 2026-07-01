{
  pkgs,
  username,
  hostname,
  flakeDir,
  ...
}:
{
  programs.mangowc = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite

    xdg-desktop-portal-wlr
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk

    grim
    slurp
    satty
    wayfreeze
    wlr-randr
  ];

  security.polkit.enable = true; # polkit
  # services.gnome.gnome-keyring.enable = true; # secret service

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ]; # or "kde"
  };

  home-manager.users.${username} =
    { config, ... }:
    {
      home.file.".config/mango/config.conf".source =
        config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/mango/config.conf";

      home.file.".config/mango/${hostname}.conf" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/mango/${hostname}.conf";
      };

      home.file.".config/mango/scripts" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/mango/scripts";
      };
    };
}
