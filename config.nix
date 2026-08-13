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

  # Like mkEnableOption, but default is false
  mkDisableOption =
    desc:
    mkOption {
      type = bool;
      default = false;
      description = desc;
    };

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
      headless = mkEnableOption "Is the host a headless device?";

      # GPU
      gpu = {
        amd = mkEnableOption "AMD GPU (RADV/amdgpu)";
        nvidia = mkEnableOption "Nvidia GPU (nvidia/nouveau)";
        intel = mkEnableOption "Intel GPU (i915/Xe)";

        nvidia-prime = {
          enable = mkDisableOption "Offload mode puts your dGPU to sleep and lets the iGPU handle all tasks";
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
        enable = mkEnableOption "Enable zram swap (compressed RAM swap)";

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

      graphicalPkgs = {
        enable = mkDisableOption "Graphical Packages";
      };

      lspPkgs = {
        base = mkEnableOption "Lightweight lsp packages";
        heavy = mkDisableOption "Heavy lsp packages";
      };

      neovim = {
        enable = mkDisableOption "Neovim Configuration";
      };

      gaming = {
        enable = mkEnableOption "Enable gaming bundle";
        steam = mkEnableOption "Enable steam";
        gamescope = mkEnableOption "Enable Gamescope (part of the bundle, can be opted out)";
        gamemode = mkEnableOption "Enable Gamemode (part of the bundle, can be opted out)";
      };

      sunshine = {
        enable = mkDisableOption "Sunshine Service";
      };

      virtualization = {
        enable = mkEnableOption "Virtualization (libvirtd + Docker)";
        libvirt.enable = mkEnableOption "Enable libvirt";
        docker = {
          enable = mkEnableOption "Enable docker";
          autostart = mkDisableOption "Enable autostart";
        };
      };

      llama = {
        enable = mkDisableOption "Enable llama service";
      };
    };
  };
}
