{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # TODO: comment out boot.loader.systemd-boot.enable = true;
  # Boot loader config for configuration.nix:
  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      {
        devices = ["nodev"];
        path = "/boot";
      }
    ];
  };

  fileSystems."/boot" = {
    # TODO: replace this with your actual config
    # device = "/dev/disk/by-uuid/2A11-F4EF";
    fsType = "vfat";
  };

  # it will be probably "zpool/local/**", need to test it

  fileSystems."/" = {
    device = "local/root";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "local/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "local/nix";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "local/var";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "local/persist";
    fsType = "zfs";
  };

  swapDevices = [{device = "/dev/zvol/local/swap";}];
}
