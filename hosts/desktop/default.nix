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
        size = 16384;
      };
    };

    de = {
      plasma.enable = true;
    };

    packages = {
      cli = {
        nvim.enable = true;
      };
      gui = {
        enable = true;
        gaming = {
          enable = true;
          steam = true;
          gamescope = true;
          gamemode = true;
        };
      };
      lsp = {
        base = true;
        heavy = true;
      };
    };

    features = {
      sunshine.enable = true;
      llama.enable = true;
    };
  };
}
