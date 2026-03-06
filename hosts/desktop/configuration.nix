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
    ../../modules/system/hardware/nvidia/nvidia.nix

    # I couldn't wire my gamepad with dongle, so I spent 3 hours to do this...
    # More in README.md
    # ../../modules/hardware/gamepad/gamepad.nix

    ../../modules/system/gaming/gaming.nix
    ../../modules/system/ai/ollama/ollama.nix
  ];

  # BOOT

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_18; # Nvidia compatibility

  environment.systemPackages = with pkgs; [
    ### Video editors
    handbrake
    losslesscut-bin
  ];
}
