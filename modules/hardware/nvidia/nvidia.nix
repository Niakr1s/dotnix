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
in {
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # You probably want stable or beta.
    package = config.boot.kernelPackages.nvidiaPackages.stable; # Same as production
    # package = config.boot.kernelPackages.nvidiaPackages.production; # Latest production driver
    # package = config.boot.kernelPackages.nvidiaPackages.beta;   # Latest beta driver
    # package = config.boot.kernelPackages.nvidiaPackages.latest; # Same as production
    # package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_535; # Older versions
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_340;
    # package = config.boot.kernelPackages.nvidiaPackages.dc; # Datacenter drivers
    # package = config.boot.kernelPackages.nvidiaPackages.dc_565;
    # package = config.boot.kernelPackages.nvidiaPackages.dc_535;

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # If you have an GPU with Turing architecture (RTX 20-Series) or newer set hardware.nvidia.open to true.
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
  };
}
