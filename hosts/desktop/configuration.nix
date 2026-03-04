{
  inputs,
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  hostname,
  username,
  stateVersion,
  ...
}: let
  unstablePkgs = import nixpkgs-unstable {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };
in {
  imports = [
    ./hardware-configuration.nix
    ../common/common.nix
    ../../modules/hardware/nvidia/nvidia.nix
    ../../modules/gaming/gaming.nix
    ../../modules/ai/ollama/ollama.nix
  ];

  # BOOT

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # boot.initrd.kernelModules = ["usbhid" "joydev" "xpad"];
  boot.kernelParams = [
    "usbcore.autosuspend=120"
    "bluetooth.disable_ertm=1"
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_18; # Nvidia compatibility

  # Encryption
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true; TODO: enable in in laptop
  environment.systemPackages = with pkgs; [
    gnomeExtensions.display-configuration-switcher
  ];

  # my dongle: 045e:028e
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="028e", ATTR{power/control}="on"
  '';

  # hardware.xone.enable = true;
  # hardware.xpadneo.enable = true;

  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      USB_DENYLIST = "045e:028e";
    };
  };
}
