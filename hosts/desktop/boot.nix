{
  config,
  lib,
  pkgs,
  modulesPath,
  system,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages; # LTS

    kernelModules = ["kvm-intel"];
    extraModulePackages = [];

    initrd = {
      availableKernelModules = [
        "ahici" # SATA controller driver
        "xhci_pci" # USB 3.0 controller driver
        "usb_storage" # USB storage devices
        "sd_mod" # SCSI disk support
        "nvme" # NVME disk support
        "usbhid" # USB Human Interface Device
      ];
      kernelModules = [
      ];
    };

    supportedFilesystems = ["ntfs"];
    loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;

      # ZFS needs this
      mirroredBoots = [
        {
          devices = ["nodev"];
          path = "/boot";
        }
      ];
    };
  };

  fileSystems."/data/ssd" = {
    device = "/dev/disk/by-uuid/01DB61C186A0F740";
    fsType = "ntfs-3g";
    options = ["rw" "uid=1000"];
  };

  fileSystems."/data/hdd1" = {
    device = "/dev/disk/by-uuid/01DAAB0556CD1D00";
    fsType = "ntfs-3g";
    options = ["rw" "uid=1000"];
  };
}
