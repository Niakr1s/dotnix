{
  lib,
  hostname,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    types
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
      default = "";
      description = desc;
    };
in
{
  options = {
    # ── core ────────────────────────────────────────────────────────────
    core = {
      # Generic
      host = mkOption {
        type = str;
        default = hostname;
        readOnly = true;
        description = "Hostname (auto-set from flake)";
      };
      user = strOpt "The primary user";
      ip = strOpt "IP";
      domain = strOpt "Domain";
      headless = mkEnableOption "Is the host a headless device?";

      # Laptop
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

      # GPU
      gpu = {
        amd = mkEnableOption "AMD GPU (RADV/amdgpu)";
        nvidia = mkEnableOption "Nvidia GPU (nvidia/nouveau)";
        intel = mkEnableOption "Intel GPU (i915/Xe)";

        nvidia-prime = {
          enable = mkOption {
            type = bool;
            default = false;
            description = "Offload mode puts your dGPU to sleep and lets the iGPU handle all tasks";
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

      # CPU
      cpu = {
        amd = mkEnableOption "AMD CPU (amd_pstate)";
        intel = mkEnableOption "Intel CPU (intel_pstate)";
      };

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
          description = "Priority of zram swap devices (higher = used first)";
        };
        swappiness = mkOption {
          type = int;
          default = 180;
          description = "vm.swappiness value (180 aggressively prefers zram over page cache eviction)";
        };
      };
    };

    # ── features ────────────────────────────────────────────────────────
    features = {
      plasma = {
        enable = mkEnableOption "Plasma Configuration";
      };

      neovim = {
        enable = mkOption {
          type = bool;
          default = false;
          description = "Neovim Configuration";
        };
      };

      gaming = {
        enable = mkEnableOption "Enable gaming bundle";
        steam = mkOption {
          type = bool;
          default = true;
          description = "Enable Steam (part of the bundle, can be opted out)";
        };
        gamescope = mkOption {
          type = bool;
          default = true;
          description = "Enable Gamescope (part of the bundle, can be opted out)";
        };
        gamemode = mkOption {
          type = bool;
          default = true;
          description = "Enable Gamemode (part of the bundle, can be opted out)";
        };
        gsr.enable = mkEnableOption "Enable GPU Screen Recorder";
      };

      sunshine = {
        enable = mkOption {
          type = bool;
          default = false;
          description = "Sunshine Configuration";
        };
        cuda = mkOption {
          type = bool;
          default = false;
          description = "Enable Nvidia Cuda support";
        };
      };

      virtualization = {
        enable = mkEnableOption "Virtualization (libvirtd + Docker)";
      };

      graphicalPkgs = {
        enable = mkOption {
          type = bool;
          default = false; # was `!headless` — the actual default depends on context
          description = "Graphical Packages";
        };
      };

      ai = {
        enable = mkOption {
          type = bool;
          default = false; # was `!headless` — depends on context
          description = "AI Tools";
        };
        llama.enable = mkOption {
          type = bool;
          default = false; # was `cfg.enable` — depends on context
          description = "Enable llama service";
        };
      };
    };
  };
}
