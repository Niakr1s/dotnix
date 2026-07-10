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
    # noctalia-shell
  ];

  security.polkit.enable = true; # polkit
  # services.gnome.gnome-keyring.enable = true; # secret service

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ]; # or "kde"
  };

  # example command
  # gtklock -b \"$(jq -r 'first(.wallpapers[].dark) // .defaultWallpaper' ~/.cache/noctalia/wallpapers.json)\" -f

  security.pam.services.gtklock = { };
  programs.gtklock = {
    enable = true;
    modules = with pkgs; [
      gtklock-virtkb-module
    ];
  };

  programs.dms-shell = {
    enable = true;

    systemd = {
      enable = true; # Systemd service for auto-start
      restartIfChanged = true; # Auto-restart dms.service when dms-shell changes
    };

    # Core features
    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableVPN = true; # VPN management widget
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
    enableCalendarEvents = true; # Calendar integration (khal)
  };

  programs.dsearch.enable = true;

  home-manager.users.${username} =
    { config, ... }:
    {
      # services.swayidle =
      #   let
      #     lock = "${pkgs.noctalia-shell}/bin/noctalia-shell ipc call sessionMenu lockAndSuspend";
      #     displayOff = "${pkgs.niri}/bin/niri msg action power-off-monitors";
      #     lockTimeout = if hostname == "laptop" then 300 else 600;
      #     displayOffTimeout = 20;
      #   in
      #   {
      #     enable = true;
      #     timeouts = [
      #       # lock and suspend
      #       {
      #         timeout = lockTimeout;
      #         command = lock;
      #       }
      #
      #       # turn off display after lock (for hosts where suspend disabled)
      #       {
      #         timeout = lockTimeout + displayOffTimeout;
      #         command = displayOff;
      #       }
      #
      #       # turn off display while idle on lockscreen
      #       {
      #         timeout = displayOffTimeout;
      #         command = "${pkgs.procps}/bin/pgrep gtklock && { ${lock}; ${displayOff}; }";
      #       }
      #     ];
      #   };

      # main config file
      home.file.".config/niri/config.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/niri/config.kdl";

      # separate configs for different hosts
      home.file.".config/niri/${hostname}.kdl" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/niri/${hostname}.kdl";
      };

      home.file.".config/DankMaterialShell/firefox.css".source =
        config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/DankMaterialShell/firefox.css";

      home.file.".config/DankMaterialShell/plugin_settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/DankMaterialShell/plugin_settings.json";

      home.file.".config/DankMaterialShell/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/DankMaterialShell/settings.json";
    };
}
