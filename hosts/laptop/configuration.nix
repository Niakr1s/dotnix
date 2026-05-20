{
  lib,
  username,
  ...
}: {
  imports = [
    # Don't change this
    ../default/configuration.nix
    ./boot.nix
    ./disko-config.nix
    ../../modules/hardware/intel.nix
    # Don't change this ------- END

    ./wallpaper.nix # You can change wallpaper in this file

    ../../modules/dconf/suspend.nix # turn on suspend for laptop
    ../../modules/dconf/onscreen-keyboard-enabler.nix

    ../../modules/de/gnome/extensions/screen-rotate.nix
    ../../modules/de/gnome/extensions/gjs-osk.nix
  ];

  # ZFS need this
  networking.hostId = "1314f71d";

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.logind = {
    settings.Login = {
      HandlePowerKey = "ignore";
      HandleLidSwitch = "ignore";
    };
  };

  hardware.sensor.iio.enable = true;

  home-manager.users.${username}.dconf.settings = {
    "re/sonny/Tangram" = {
      instances = [
        "v2raya"
        "qbittorrent"
      ];
    };

    "org/gnome/shell/extensions/vitals" = {
      update-time = lib.mkForce 10;

      hot-sensors = lib.mkForce [
        # cpu
        "_processor_usage_"
        "_memory_usage_"
        "__temperature_avg__"

        # network
        "__network-rx_max__"
      ];
    };
  };

  services.iio-niri = {
    enable = true;
  };
}
