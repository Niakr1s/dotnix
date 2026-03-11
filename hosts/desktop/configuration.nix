{
  inputs,
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  disko,
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
    ./boot.nix
    ./disko-config.nix
    ../../modules/hardware/nvidia/nvidia.nix
    # Don't change this ------- END

    ./wallpaper.nix
    ./bookmarks.nix

    ./veracrypt_volumes.nix

    ../../modules/dconf/dconf.multiple.monitors.nix
    ../../modules/dconf/dconf.numlock.nix

    ../../modules/de/gnome/extensions/blur-my-shell.nix
    ../../modules/de/gnome/extensions/display-configuration-switcher.nix

    ../../modules/ai/ollama/ollama.nix
    ../../modules/ai/aichat/aichat.nix

    ../../modules/gaming/gaming.nix
    # ../../modules/hardware/gamepad/gamepad.nix
    ../../modules/gaming/lutris/lutris.nix
    ../../modules/gaming/mangohud/mangohud.nix

    ../../modules/video/handbrake/handbrake.nix
    ../../modules/video/losslesscut/losslesscut.nix
  ];

  # ZFS need this
  networking.hostId = "82473af6";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
