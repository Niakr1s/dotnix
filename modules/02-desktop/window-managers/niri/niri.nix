{
  pkgs,
  username,
  hostname,
  flakeDir,
  ...
}:
{
  imports = [
    ./dms.nix
  ];

  programs.niri = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    # noctalia-shell
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
      # main config file
      home.file.".config/niri/config.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/niri/config.kdl";

      # separate configs for different hosts
      home.file.".config/niri/${hostname}.kdl" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/niri/${hostname}.kdl";
      };
    };
}
