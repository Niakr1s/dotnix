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
  ];

  # BOOT

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_18; # Nvidia compatibility

  # Encryption
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  # AI

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = ["gemma3:12b"];
  };

  # GAMING

  # https://github.com/lutris/docs/blob/master/HowToEsync.md
  # The Lutris documentation shows how to make your system esync compatible. These steps can be achieved on NixOS with the config below
  # systemd.extraConfig = "DefaultLimitNOFILE=524288"; deprecated, using systemd.settings.Manager
  systemd.settings.Manager = {
    DefaultLimitNOFILE = 524288;
  };
  security.pam.loginLimits = [
    {
      domain = "${username}"; # your user name
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];
  programs.steam.enable = true;
  programs.gamemode.enable = true; # for performance mode

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true; TODO: enable in in laptop
}
