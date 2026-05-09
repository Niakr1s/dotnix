{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages; # LTS

    kernelModules = ["kvm-intel"];
    extraModulePackages = [];

    initrd = {
      availableKernelModules = [
        "ahci" # SATA controller driver
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

    # kernelParams = ["zfs.zfs_arc_max=12884901888"]; # 12GB × (1024×1024×1024)
  };

  fileSystems."/data/ssd" = {
    device = "/dev/disk/by-uuid/01DB61C186A0F740";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000" # first users's uid
      "gid=100" # users group
    ];
  };

  fileSystems."/data/hdd1" = {
    device = "/dev/disk/by-uuid/0ea69abb-b36c-4e10-820d-597c2df3b13f";
    fsType = "ext4";
    options = [
      "rw"
      "noatime"
    ];
  };
}
