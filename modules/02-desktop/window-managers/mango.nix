{
  pkgs,
  username,
  hostname,
  flakeLib,
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

  imports = [
    (flakeLib.mkHomeLink ".config/mango/config.conf")
    (flakeLib.mkHomeLink ".config/mango/${hostname}.conf")
    (flakeLib.mkHomeLink ".config/mango/scripts")
  ];
}
