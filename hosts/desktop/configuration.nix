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
  disko = builtins.fetchTarball {
    url = "https://github.com/nix-community/disko/archive/refs/tags/v1.13.0.tar.gz";
    sha256 = "03jz60kw0khm1lp72q65z8gq69bfrqqbj08kw0hbiav1qh3g7p08";
  };
in {
  imports = [
    # Don't change this
    ./hardware-configuration.nix
    "${disko}/module.nix"
    ./disko-config.nix
    ../default/configuration.nix
    ../../modules/system/hardware/nvidia/nvidia.nix
    # Don't change this ------- END

    # I couldn't wire my gamepad with dongle, so I spent 3 hours to do this...
    # ../../modules/hardware/gamepad/gamepad.nix

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
