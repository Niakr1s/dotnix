{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.modules.de.niri;
  user = config.modules.core.user;
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xwayland-satellite # xwayland support
      alacritty
      nautilus
      gnome-text-editor

      # themes
      adwaita-icon-theme
      adwaita-qt
      adwaita-qt6
      adwaita-fonts

      # fixes for qt applications
      libsForQt5.qt5ct
      kdePackages.qt6ct
    ];

    environment.sessionVariables = {
      XCURSOR_THEME = "Adwaita";
      XCURSOR_SIZE = "24"; # Set your desired cursor size here
    };

    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "adwaita-dark";
    };

    programs.kdeconnect.enable = true;

    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri"; # Or "hyprland" or "sway"

      # Sync your user's DankMaterialShell theme with the greeter. You'll probably want this
      configHome = "/home/${user}";

      # Save the logs to a file
      logs = {
        save = true;
        path = "/tmp/dms-greeter.log";
      };
    };

    programs.dconf.enable = true;

    programs.niri = {
      enable = true;
      useNautilus = true;
    };
    security.polkit.enable = true; # polkit
    services.gnome.gnome-keyring.enable = true; # secret service

    programs.dms-shell = {
      enable = true;

      systemd = {
        enable = true; # Systemd service for auto-start
        restartIfChanged = true; # Auto-restart dms.service when dms-shell changes
      };

      # Core features
      enableSystemMonitoring = true; # System monitoring widgets (dgop)
      enableVPN = false; # VPN management widget
      enableDynamicTheming = false; # Wallpaper-based theming (matugen)
      enableAudioWavelength = false; # Audio visualizer (cava)
      enableCalendarEvents = false; # Calendar integration (khal)
    };

  };
}
