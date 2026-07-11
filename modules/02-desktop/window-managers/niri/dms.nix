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
      home.file.".config/niri/dms".source =
        config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/niri/dms";

      home.file.".config/DankMaterialShell".source =
        config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/DankMaterialShell";
    };
}
