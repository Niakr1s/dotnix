{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkMerge mkIf;
  gpu = config.core.gpu;
in
{
  config = mkMerge [
    (mkIf gpu.amd {
      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            rocmPackages.clr.icd
            libvdpau-va-gl
          ];
        };
        amdgpu.opencl.enable = true;
      };
      environment.systemPackages = with pkgs; [
        libva-utils
        radeontop
      ];
    })

    (mkIf gpu.nvidia {
      services.xserver.videoDrivers = [ "nvidia" ];
      boot = {
        blacklistedKernelModules = [ "nouveau" ];
        kernelParams = [
          "modprobe.blacklist=nouveau"
          "nvidia_drm.fbdev=1"
        ];
      };
      hardware = {
        graphics = {
          enable = true;
          extraPackages = with pkgs; [ nvidia-vaapi-driver ];
        };
        nvidia-container-toolkit.enable = true;
        nvidia = {
          modesetting.enable = true;
          powerManagement.enable = true;
          open = false;
          package = config.boot.kernelPackages.nvidiaPackages.stable;
          nvidiaSettings = true;
        };
      };
      services.nvidia-pstated.enable = true;
    })

    (mkIf gpu.nvidia-prime.enable {
      hardware.nvidia.prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;

        intelBusId = lib.mkIf (gpu.nvidia-prime.iGPU == "intel") "PCI:0@0:2:0";
        amdgpuBusId   = lib.mkIf (gpu.nvidia-prime.iGPU == "amd")   "PCI:5@0:0:0";

        nvidiaBusId = "PCI:1@0:0:0"; # Укажите адрес вашей dGPU!
      };
    })

    (mkIf gpu.intel {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver
          vpl-gpu-rt
        ];
        extraPackages32 = with pkgs; [ intel-vaapi-driver ];
      };
      environment = {
        sessionVariables.LIBVA_DRIVER_NAME = "iHD";
        systemPackages = with pkgs; [ intel-gpu-tools ];
      };
    })
  ];
}
