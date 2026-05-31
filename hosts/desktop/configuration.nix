{
  config,
  lib,
  ...
}: {
  imports = [
    # Don't change this
    ../default/configuration.nix
    ./boot.nix
    ./disko-config.nix
    ../../modules/01-system/hardware/gpu/nvidia.nix
    # Don't change this ------- END

    ./wallpaper.nix
    ./bookmarks.nix
    ./aliases.nix
    ./software.nix
  ];

  # ZFS need this
  networking.hostId = "82473af6";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
}
