{
  lib,
  pkgs,
  hostname,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    ;

  # Like enabled, but default is false
  disabled =
    desc:
    mkOption {
      type = types.bool;
      default = false;
      description = desc;
    };

  enabled =
    desc:
    mkOption {
      type = types.bool;
      default = true;
      description = desc;
    };
in
{
  options.modules = {
    # ── core ────────────────────────────────────────────────────────────
    core = {
      # Generic
      host = mkOption {
        type = types.str;
        default = hostname;
        readOnly = true;
        description = "Hostname (auto-set from flake)";
      };
      user = mkOption {
        type = types.str;
        default = "";
        description = "The primary user";
      };
      headless = enabled "Is the host a headless device?";

      # GPU
      gpu = {
        amd.enable = disabled "AMD GPU (RADV/amdgpu)";
        intel.enable = disabled "Intel GPU (i915/Xe)";

        nvidia = {
          enable = disabled "Nvidia GPU (nvidia/nouveau)";
          prime = {
            enable = disabled "Offload mode puts your dGPU to sleep and lets the iGPU handle all tasks";
          };
        };
      };

      # CPU
      cpu = {
        amd = disabled "AMD CPU (amd_pstate)";
        intel = disabled "Intel CPU (intel_pstate)";
      };

      virtualization = {
        enable = enabled "Virtualization (libvirtd + Docker)";
        libvirt.enable = enabled "Enable libvirt";
        docker = {
          enable = enabled "Enable docker";
          autostart = disabled "Enable autostart";
        };
      };

      # Zram
      zram = {
        enable = enabled "Enable zram swap (compressed RAM swap)";
        percent = mkOption {
          type = types.int;
          default = 50;
          description = "Percentage of RAM";
        };
      };
    };

    de = {
      plasma = {
        enable = enabled "Plasma Configuration";
      };
    };

    packages = {
      # all cli packages are turned on by default
      cli = {
        nvim = {
          enable = enabled "Neovim Configuration";
        };
        dev = {
          buildtools = enabled "Build tools (make, cmake, ...)";

          langs = {
            bundles = {
              functional = disabled "functional (elixir, crystal, nim)";
            };

            cpp = enabled "c/c++";
            go = enabled "golang";
            haskell = disabled "haskell";
            java = disabled "java";
            lua = enabled "lua";
            node = enabled "nodejs";
            perl = disabled "perl";
            php = disabled "php";
            python = enabled "python";
            ruby = disabled "ruby";
            rust = enabled "rust";
            zig = disabled "zig";
          };
        };
      };
      gui = {
        enable = disabled "GUI Packages";
        zed.enable = disabled "Zed editor";
        winboat.enable = disabled "Winboat (running windows native apps)";
        blender.enable = disabled "Blender";
        obs.enable = disabled "obs-studio";
      };
      gaming = {
        enable = disabled "Enable gaming bundle (steam + lutris)";
        wine = mkOption {
          type = types.package;
          default = pkgs.wineWow64Packages.stagingFull;
          description = "Wine version";
        };
        # TODO: emulators
      };
      lsp = {
        base = enabled "Lightweight lsp packages";
        heavy = disabled "Heavy lsp packages";
      };
    };

    services = {
      avahi = {
        enable = enabled "Avahi Service";
      };

      llama = {
        enable = disabled "Llama service";
      };

      sunshine = {
        enable = disabled "Sunshine Service";
      };

      syncthing = {
        enable = disabled "Syncthing Service";
      };

      v2raya = {
        enable = enabled "v2raya Service";
      };
    };
  };
}
