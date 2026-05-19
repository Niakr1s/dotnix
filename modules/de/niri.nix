{
  config,
  pkgs,
  username,
  flakeDir,
  ...
}: {
  imports = [
    ../wvkbd.nix
  ];

  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite

    alacritty
    # fuzzel
    # swaylock
    # mako
    # swayidle

    unstable.noctalia-shell

    (writeShellScriptBin "wvkbd-deskintl" ''
      wvkbd-deskintl -l full,cyrillic --landscape-layers full,cyrillic
    '')
  ];

  # security.polkit.enable = true; # polkit
  # services.gnome.gnome-keyring.enable = true; # secret service
  # security.pam.services.swaylock = {};

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = ["gtk"]; # or "kde"
  };

  home-manager.users.${username} = {config, ...}: {
    home.file.".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/niri/config.kdl";

    home.file.".config/niri/noctalia.kdl" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/niri/noctalia.kdl";
      recursive = true;
    };

    home.file.".config/noctalia" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/noctalia";
    };

    home.file.".config/alacritty" = {
      # TODO: probably move to a separate module, too lazy atm
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/alacritty";
      recursive = true;
    };
  };
}
