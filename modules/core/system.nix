{
  config,
  ...
}:
let
  user = config.modules.core.user;
in
{
  networking.networkmanager.enable = true;

  # Disable power management/autosuspend for the faulty Bluetooth driver
  boot.extraModprobeConfig = ''
    options btusb enable_autosuspend=0
  '';
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    # Configure BlueZ main.conf settings
    settings = {
      General = {
        FastConnectable = false;
        Privacy = "off";
      };
    };
  };

  users.users.${user} = {
    group = user;
    extraGroups = [ "networkmanager" ];
  };

  documentation = {
    dev.enable = true;
    man.enable = true;
  };
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };
}
