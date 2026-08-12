{
  config,
  lib,
  flakeLib,
  ...
}:
let
  port = lib.strings.toInt (
    lib.last (lib.strings.splitString ":" config.services.syncthing.guiAddress)
  );
  user = config.core.user;
in
{
  imports = [
    (flakeLib.localhostReverseProxy "syncthing" port { insecureTLS = true; })
  ];

  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing.
    user = user;
    group = "users";
    dataDir = "/home/${user}";
  };
}
