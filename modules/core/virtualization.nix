{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.features.virtualization;
  user = config.modules.core.user;
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
        enable = cfg.docker.enable;
        enableOnBoot = cfg.docker.autostart;
        autoPrune.enable = true;
      };
    };
  };
}
