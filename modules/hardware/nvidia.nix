{ config, ... }:
{
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    # Enable OpenGL
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia-container-toolkit.enable = true; # for docker

    nvidia = {
      # You probably want stable or beta.
      # Commonly interesting branches for end users:
      #     production, new_feature, beta: NVIDIA's official production / new feature / beta release branches.
      #     stable: The default; the highest stable version.
      #     latest: Whichever is newer of production and new_feature.
      #     bleeding_edge: Whichever is newer of latest and beta.
      #     legacy_580: The long-lived 580 series (LTSB), for GPUs that newer driver branches no longer support (often Maxwell through Volta; roughly GeForce GTX 9xx through 10xx, plus rare Volta cards like TITAN V).
      #     vulkan_beta: The Vulkan developer beta driver, for users interested in testing new Vulkan features.
      branch = "stable";

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
  };
}
