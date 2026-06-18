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
    ../../modules/01-system/hardware/gpu/intel.nix
    # Don't change this ------- END

    ./wallpaper.nix # You can change wallpaper in this file
  ];

  # ZFS need this
  networking.hostId = "1314f71d";

  services.upower.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "perfomance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "perfomance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_BOOST_ON_BAT = 0;
    };
  };

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
