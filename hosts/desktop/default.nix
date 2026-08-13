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

  core = {
    user = "user";

    gpu = {
      intel = true;
      nvidia = true;

      nvidia-prime = {
        enable = true;
        iGPU = "intel";
      };
    };

    cpu.intel = true;
    zram.size = 16384;
  };
  features = {
    neovim.enable = true;
    virtualization = {
      enable = true;
      libvirt.enable = true;
      docker = {
        enable = true;
        autostart = true;
      };
    };
    sunshine.enable = true;
    graphicalPkgs.enable = true;
    lspPkgs = {
      base = true;
      heavy = true;
    };

    gaming = {
      enable = true;
      steam = true;
      gamescope = true;
      gamemode = true;
    };
    plasma = {
      enable = true;
    };
    llama.enable = true;
  };
}
