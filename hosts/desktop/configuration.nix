{
  inputs,
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  disko,
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
    # Don't change this
    ../default/configuration.nix
    ./hardware-configuration.nix
    ./disko-config.nix
    # Don't change this ------- END

    # I couldn't wire my gamepad with dongle, so I spent 3 hours to do this...
    # ../../modules/hardware/gamepad/gamepad.nix

    ../../modules/system/hardware/nvidia/nvidia.nix
    ../../modules/system/gaming/gaming.nix
    ../../modules/system/ai/ollama/ollama.nix
    ../../modules/home/lutris/lutris.nix
  ];

  # BOOT
  boot = {
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

  # ZFS need this
  networking.hostId = "82473af6";

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  environment.systemPackages = with pkgs; [
    ### Video editors
    handbrake
    losslesscut-bin
  ];
}
