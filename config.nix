{
  lib,
  pkgs,
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
  options.modules = {
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
        amd.enable = mkEnableOption "AMD GPU (RADV/amdgpu)";
        intel.enable = mkEnableOption "Intel GPU (i915/Xe)";

        nvidia = {
          enable = mkEnableOption "Nvidia GPU (nvidia/nouveau)";
          prime = {
            enable = mkDisableOption "Offload mode puts your dGPU to sleep and lets the iGPU handle all tasks";
          };
        };
      };

      # CPU
      cpu = {
        amd = mkEnableOption "AMD CPU (amd_pstate)";
        intel = mkEnableOption "Intel CPU (intel_pstate)";
      };

      virtualization = {
        enable = mkEnableOption "Virtualization (libvirtd + Docker)";
        libvirt.enable = mkEnableOption "Enable libvirt";
        docker = {
          enable = mkEnableOption "Enable docker";
          autostart = mkDisableOption "Enable autostart";
        };
      };

      # Zram
      zram = {
        enable = mkEnableOption "Enable zram swap (compressed RAM swap)";
        percent = mkOption {
          type = int;
          default = 50;
          description = "Percentage of RAM";
        };
      };
    };

    de = {
      plasma = {
        enable = mkEnableOption "Plasma Configuration";
      };
    };

    packages = {
      # all cli packages are turned on by default
      cli = {
        nvim = {
          enable = mkEnableOption "Neovim Configuration";
        };
      };
      gui = {
        enable = mkDisableOption "GUI Packages";
        zed = {
          enable = mkDisableOption "Zed editor";
        };
        winboat = {
          enable = mkDisableOption "Winboat (running windows native apps)";
        };
      };
      gaming = {
        enable = mkDisableOption "Enable gaming bundle (steam + lutris)";
        wine = mkOption {
          type = types.package;
          default = pkgs.wineWow64Packages.stagingFull;
          description = "Wine version";
        };
        # TODO: emulators
      };
      lsp = {
        base = mkEnableOption "Lightweight lsp packages";
        heavy = mkDisableOption "Heavy lsp packages";
      };
    };

    services = {
      avahi = {
        enable = mkEnableOption "Avahi Service";
      };

      llama = {
        enable = mkDisableOption "Llama service";
      };

      sunshine = {
        enable = mkDisableOption "Sunshine Service";
      };

      syncthing = {
        enable = mkDisableOption "Syncthing Service";
      };

      v2raya = {
        enable = mkEnableOption "v2raya Service";
      };
    };
  };
}
