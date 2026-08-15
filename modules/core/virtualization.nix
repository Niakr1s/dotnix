{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.core.virtualization;
  user = config.modules.core.user;
in
{
  config = lib.mkIf cfg.enable {
    users.users.${user} = {
      linger = true; # linger containers after logout
      extraGroups = [
        "docker"
      ];
    };

    virtualisation = {
      libvirtd.enable = true;
      containers.enable = true;
      oci-containers.backend = "podman";
      podman = {
        enable = cfg.docker.enable;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
      };
    };
  };
}
