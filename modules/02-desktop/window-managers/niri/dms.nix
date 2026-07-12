{
  flakeLib,
  ...
}:
{
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

    plugins = {
      dankActions.enable = true;
      # nvidiaGpuMonitor.enable = true;
    };
  };

  programs.dsearch.enable = true;

  imports = [
    (flakeLib.mkHomeLink ".config/niri/dms")
    (flakeLib.mkHomeLink ".config/DankMaterialShell/themes")
    (flakeLib.mkHomeLink ".config/DankMaterialShell/firefox.css")
    (flakeLib.mkHomeLink ".config/DankMaterialShell/plugin_settings.json")
    (flakeLib.mkHomeLink ".config/DankMaterialShell/settings.json")
  ];
}
