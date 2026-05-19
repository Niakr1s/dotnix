{
  config,
  lib,
  ...
}: {
  imports = [
    # Don't change this
    ../default/configuration.nix
    ./boot.nix
    ./disko-config.nix
    ../../modules/hardware/nvidia.nix
    # Don't change this ------- END

    ./wallpaper.nix
    ./bookmarks.nix
    ./aliases.nix
    ./software.nix
    ./games.nix
    # ./ups.nix

    ../../modules/dconf/monitors.nix
    ../../modules/dconf/numlock.nix

    # ../../modules/de/gnome/extensions/blur-my-shell.nix
    ../../modules/de/gnome/extensions/display-configuration-switcher.nix

    ../../modules/ai/ollama.nix
    ../../modules/ai/aichat.nix
    # ../../modules/ai/comfyui.nix # building from src, too long

    ../../modules/video/handbrake.nix
    ../../modules/video/losslesscut.nix
    ../../modules/video/obs.nix

    ../../modules/services/kiwix.nix
  ];

  # ZFS need this
  networking.hostId = "82473af6";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
}
