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
in
{
  imports = [
    (flakeLib.localhostReverseProxy "syncthing" port)
  ];

  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing.
  };
}
