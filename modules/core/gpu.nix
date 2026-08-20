{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkMerge mkIf;
  gpu = config.modules.core.gpu;
  cpu = config.modules.core.cpu;
in {
  config = mkMerge [
    (mkIf gpu.amd.enable {
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

    (mkIf gpu.nvidia.enable {
      services.xserver.videoDrivers = ["nvidia"];
      boot = {
        blacklistedKernelModules = ["nouveau"];
        kernelParams = [
          "modprobe.blacklist=nouveau"
          "nvidia_drm.fbdev=1"
        ];
      };
      hardware = {
        graphics = {
          enable = true;
          extraPackages = with pkgs; [nvidia-vaapi-driver];
        };
        nvidia-container-toolkit.enable = true;
        nvidia = {
          modesetting.enable = true;
          powerManagement.enable = true;
          open = false;
          package = config.boot.kernelPackages.nvidiaPackages.stable;
          nvidiaSettings = true;
          prime = mkIf gpu.nvidia.prime.enable {
            offload.enable = true;
            offload.enableOffloadCmd = true;
            nvidiaBusId = "PCI:1@0:0:0"; # dGPU address

            # iGPU address
            intelBusId = lib.mkIf (cpu.intel) "PCI:0@0:2:0";
            amdgpuBusId = lib.mkIf (cpu.amd) "PCI:5@0:0:0";
          };
        };
      };
      services.nvidia-pstated.enable = true;
    })

    (mkIf gpu.intel.enable {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver
          vpl-gpu-rt
        ];
        extraPackages32 = with pkgs; [intel-vaapi-driver];
      };
      environment = {
        sessionVariables.LIBVA_DRIVER_NAME = "iHD";
        systemPackages = with pkgs; [intel-gpu-tools];
      };
    })
  ];
}
