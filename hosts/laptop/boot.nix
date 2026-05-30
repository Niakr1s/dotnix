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
        "sdhci_pci" # SD card host controller
        "rtsx_usb_sdmmc" # Realtek USB SD card reader
      ];
      kernelModules = [
      ];

      # kernelParams = ["zfs.zfs_arc_max=2147483648"]; # 2GB × (1024×1024×1024)
    };
  };
}
