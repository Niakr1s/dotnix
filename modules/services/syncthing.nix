{
  config,
  lib,
  flakeLib,
  ...
}: let
  cfg = config.modules.services.syncthing;
  port = lib.strings.toInt (
    lib.last (lib.strings.splitString ":" config.services.syncthing.guiAddress)
  );
  user = config.modules.core.user;
in {
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.syncthing = {
          enable = true;
          openDefaultPorts = true; # Open ports in the firewall for Syncthing.
          user = user;
          group = "users";
          dataDir = "/home/${user}";
        };
      }
      (flakeLib.localhostReverseProxy "syncthing" port {insecureTLS = true;})
    ]
  );
}
