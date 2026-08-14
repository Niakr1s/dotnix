{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
  ];

  environment.systemPackages = [
    (pkgs.writeScriptBin "manage-disks" (builtins.readFile ./scripts/manage-disks.sh))
    (pkgs.writeScriptBin "monitor-toggle" (builtins.readFile ./scripts/monitor-toggle.sh))
  ];

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  modules = {
    core = {
      user = "user";
      headless = false;

      gpu = {
        intel.enable = true;
        nvidia = {
          enable = true;
          prime.enable = true;
        };
      };

      cpu.intel = true;

      virtualization = {
        enable = true;
        libvirt.enable = true;
        docker = {
          enable = true;
          autostart = true;
        };
      };

      zram = {
        enable = true;
        percent = 200;
      };
    };

    de = {
      plasma.enable = true;
    };

    packages = {
      cli = {
        nvim.enable = true;

        dev = {
          buildtools = true;
          langs = {
            bundles.functional = false;

            cpp = true;
            go = true;
            haskell = false;
            java = true;
            lua = true;
            node = true;
            perl = false;
            php = false;
            python = true;
            ruby = false;
            rust = true;
            zig = true;
          };
        };
      };
      gui = {
        enable = true;
        zed.enable = true;
        winboat.enable = true;
      };
      gaming = {
        enable = true;
      };
      lsp = {
        base = true;
        heavy = true;
      };
    };

    services = {
      avahi.enable = true;
      llama.enable = true;
      sunshine.enable = true;
      syncthing.enable = true;
      v2raya.enable = true;
    };
  };
}
