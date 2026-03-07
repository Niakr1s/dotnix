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
    ./boot.nix
    ./disko-config.nix
    # Don't change this ------- END

    # I couldn't wire my gamepad with dongle, so I spent 3 hours to do this...
    # ../../modules/hardware/gamepad/gamepad.nix

    ../../modules/hardware/nvidia/nvidia.nix
    ../../modules/gaming/gaming.nix
    ../../modules/ai/ollama/ollama.nix
    ../../modules/gaming/lutris/lutris.nix
  ];

  # ZFS need this
  networking.hostId = "82473af6";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  environment.systemPackages = with pkgs; [
    ### Video editors
    handbrake
    losslesscut-bin
  ];
}
