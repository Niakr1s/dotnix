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

      zram = {
        enable = true;
        size = 16384;
      };
    };
    features = {
      plasma.enable = true;
      graphicalPkgs.enable = true;
      lspPkgs = {
        base = true;
        heavy = true;
      };
      neovim.enable = true;
      gaming = {
        enable = true;
        steam = true;
        gamescope = true;
        gamemode = true;
      };
      sunshine.enable = true;
      virtualization = {
        enable = true;
        libvirt.enable = true;
        docker = {
          enable = true;
          autostart = true;
        };
      };
      llama.enable = true;
    };
  };
}
