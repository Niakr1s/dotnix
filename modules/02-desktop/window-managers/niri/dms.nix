{
  pkgs,
  username,
  hostname,
  flakeDir,
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
  };

  programs.dsearch.enable = true;

  home-manager.users.${username} =
    { config, ... }:
    {
      # main config file
      home.file.".config/niri/dms".source =
        config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/niri/dms";

      home.file.".config/DankMaterialShell/themes".source =
        config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/DankMaterialShell/themes";

      home.file.".config/DankMaterialShell/firefox.css".source =
        config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/DankMaterialShell/firefox.css";

      home.file.".config/DankMaterialShell/plugin_settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/DankMaterialShell/plugin_settings.json";

      home.file.".config/DankMaterialShell/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/DankMaterialShell/settings.json";
    };
}
