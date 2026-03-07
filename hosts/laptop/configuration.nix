{
  inputs,
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  hostname,
  username,
  ...
}: let
  unstablePkgs = import nixpkgs-unstable {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };
in {
  imports = [
    # Don't change this
    ../default/configuration.nix
    ./hardware-configuration.nix
    ../../modules/hardware/intel/intel.nix
    # Don't change this ------- END

    ./wallpaper.nix # You can change wallpaper in this file

    # ../../modules/dconf/dconf.suspend.nix # turn on suspend for laptop

    ../../modules/de/gnome/extensions/screen-rotate.nix
    ../../modules/de/gnome/extensions/gjs-osk.nix
  ];

  # BOOT

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages; # LTS

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  hardware.sensor.iio.enable = true;
}
