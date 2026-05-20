{
  pkgs,
  username,
  hostname,
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
  ];

  security.polkit.enable = true; # polkit
  # services.gnome.gnome-keyring.enable = true; # secret service

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = ["gtk"]; # or "kde"
  };

  # example command
  # gtklock -b \"$(jq -r 'first(.wallpapers[].dark) // .defaultWallpaper' ~/.cache/noctalia/wallpapers.json)\" -f

  security.pam.services.gtklock = {};
  programs.gtklock = {
    enable = true;
    modules = with pkgs; [
      gtklock-virtkb-module
      # gtklock-powerbar-module
      gtklock-userinfo-module
    ];
  };

  home-manager.users.${username} = {config, ...}: {
    services.swayidle = let
      # Lock command
      lock = "${pkgs.unstable.noctalia-shell}/bin/noctalia-shell ipc call sessionMenu lockAndSuspend";
      displayOff = "${pkgs.niri}/bin/niri msg action power-off-monitors";
    in {
      enable = true;
      timeouts = [
        {
          timeout = 20;
          command = lock;
        }
        {
          timeout = 25;
          command = displayOff;
        }
      ];
      events = [
        {
          event = "before-sleep";
          # adding duplicated entries for the same event may not work
          command = displayOff + "; " + lock;
        }
        {
          event = "lock";
          command = displayOff + "; " + lock;
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
