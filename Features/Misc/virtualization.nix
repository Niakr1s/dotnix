{
  lib,
  config,
  ...
}:
let
  cfg = config.features.virtualization;
  user = config.core.user;
  isLaptop = config.core.isLaptop.enable;
in
{
  config = lib.mkIf cfg.enable {
    users.users.${user} = {
      group = user;
      extraGroups = [
        "docker"
      ];
    };

    virtualisation = {
      libvirtd.enable = true;
      docker = {
        enable = true;
        enableOnBoot = !isLaptop;
        autoPrune.enable = true;
      };
    };
  };
}
