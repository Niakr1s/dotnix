{
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    types
    filterAttrs
    hasSuffix
    ;
  inherit (types)
    str
    bool
    int
    enum
    ;

  strOpt =
    desc:
    mkOption {
      type = str;
      description = desc;
      default = "";
    };
in
{
  options = {
    core = {
      # Generic
      user = strOpt "The primary user";
      ip = strOpt "IP";
      headless = mkEnableOption "Is the host a headless device?";

      # Laptop stuff

      isLaptop = {
        enable = mkOption {
          type = bool;
          default = false;
          description = "Whether this host is a laptop (enables battery-aware features)";
        };
        usesPPD = mkEnableOption "PPD daemon";
        usesAuto-cpufreq = mkEnableOption "uses auto-cpufreq";
        usesTunedPPD = mkEnableOption "TuneD PPD daemon (power-profiles-daemon compatible)";
      };

      # gpu
      gpu = {
        amd = mkEnableOption "AMD GPU (RADV/amdgpu)";
        nvidia = mkEnableOption "Nvidia GPU (nvidia/nouveau)";
        intel = mkEnableOption "Intel GPU (i915/Xe)";

        nvidia-prime = {
          enable = mkOption {
            type = bool;
            default = false;
            description = "Offload mode puts your dGPU to sleep and lets the iGPU handle all tasks, except if you call the dGPU specifically by offloading an application to it";
          };
          iGPU = mkOption {
            type = enum [
              "intel"
              "amd"
            ];
            default = "intel";
            description = "Choose your iGPU";
          };
        };
      };

      # Cpu
      cpu = {
        amd = mkEnableOption "AMD CPU (amd_pstate)";
        intel = mkEnableOption "Intel CPU (intel_pstate)";
      };

      domain = strOpt "Domain";
      # Zram
      zram = {
        enable = mkOption {
          type = bool;
          default = true;
          description = "Enable zram swap (compressed RAM swap)";
        };
        algorithm = mkOption {
          type = enum [
            "lzo"
            "lzo-rle"
            "lz4"
            "lz4hc"
            "zstd"
            "deflate"
            "842"
          ];
          default = "zstd";
          description = "Compression algorithm for zram";
        };

        size = mkOption {
          type = int;
          default = 2048;
          description = "Fixed zram size in MiB (2048 = 2GiB)";
        };
        priority = mkOption {
          type = int;
          default = 100;
          description = "Priority of zram swap devices (higher = used first, ensures zram is preferred over disk swap)";
        };

        swappiness = mkOption {
          type = int;
          default = 180;
          description = "vm.swappiness value (180 aggressively prefers zram over page cache eviction)";
        };
      };
    };
  };
}
