{
  config,
  pkgs,
  ...
}:
let
  user = config.core.user;
in
{
  imports = [
    ./hardware.nix
    ../../Features
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
    git = {
      email = "pavel2188@gmail.com";
      user = "Niakr1s";
    };
  };
  features = {
    neovim.enable = true;
    virtualization.enable = true;
    sunshine.enable = true;

    gaming = {
      enable = true;
    };
    plasma = {
      enable = true;
    };
  };
}
