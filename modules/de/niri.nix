{
  config,
  pkgs,
  username,
  flakeDir,
  ...
}: {
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    fuzzel
    swaylock
    mako
    swayidle
  ];

  security.polkit.enable = true; # polkit
  services.gnome.gnome-keyring.enable = true; # secret service
  security.pam.services.swaylock = {};

  programs.waybar.enable = true; # top bar

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = ["gtk"]; # or "kde"
  };

  home-manager.users.${username} = {config, ...}: {
    home.file.".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/niri/config.kdl";
  };
}
