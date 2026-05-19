{
  pkgs,
  username,
  hostname,
  flakeDir,
  ...
}: let
  swayTimeouts = {
    "desktop" = 600;
    "laptop" = 300;
  };
  postLockCommand =
    if "${hostname}" == "laptop"
    then "systemctl suspend"
    else "${pkgs.niri}/bin/niri msg action power-off-monitors";
in {
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
  ];

  security.polkit.enable = true; # polkit
  # services.gnome.gnome-keyring.enable = true; # secret service
  # security.pam.services.swaylock = {};

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = ["gtk"]; # or "kde"
  };

  home-manager.users.${username} = {config, ...}: {
    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = swayTimeouts."${hostname}";
          command = "${pkgs.unstable.noctalia-shell}/bin/noctalia-shell ipc call sessionMenu lock";
        }
        {
          timeout = swayTimeouts."${hostname}" + 30;
          command = "${postLockCommand}";
        }
      ];
    };

    home.file.".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/niri/config.kdl";

    home.file.".config/niri/noctalia.kdl" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/niri/noctalia.kdl";
      recursive = true;
    };

    home.file.".config/noctalia" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/noctalia";
    };

    home.file.".config/niri/host" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/niri/hosts/${hostname}";
      recursive = true;
    };

    home.file.".config/alacritty" = {
      # TODO: probably move to a separate module, too lazy atm
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/alacritty";
      recursive = true;
    };
  };
}
