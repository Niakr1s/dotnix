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
      availableKernelModules = ["ahci" "xhci_pci" "usb_storage" "sd_mod" "sdhci_pci" "rtsx_usb_sdmmc"];
      kernelModules = ["dm-snapshot"];
    };

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
}
