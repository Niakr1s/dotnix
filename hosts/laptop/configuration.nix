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
    ../default/configuration.nix
    ../../modules/system/hardware/intel/intel.nix
  ];

  # BOOT

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

  # Encryption
  # boot.initrd.luks.devices = {
  #   root = {
  #     device = "/dev/nvme0n1p2";
  #     preLVM = true;
  #   };
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
}
