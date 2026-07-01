{
  pkgs,
  username,
  hostname,
  flakeDir,
  ...
}:
{
  programs.niri = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    noctalia-shell
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
      home.file.".config/niri/config.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/niri/config.kdl";

      home.file.".config/niri/noctalia.kdl" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/niri/noctalia.kdl";
        recursive = true;
      };

      home.file.".config/niri/${hostname}.kdl" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/niri/${hostname}.kdl";
      };
    };
}
