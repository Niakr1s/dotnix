{
  config,
  lib,
  flakeLib,
  username,
  ...
}:
let
  sopsPath = "common/syncthing";

  port = lib.strings.toInt (
    lib.last (lib.strings.splitString ":" config.services.syncthing.guiAddress)
  );
in
{
  imports = [
    (flakeLib.localhostReverseProxy "syncthing" port)
  ];

  sops.secrets = {
    # This is the actual specification of the secrets.
    "${sopsPath}" = {
      mode = "0440";
      owner = config.users.users.${username}.name;
      group = config.users.users.${username}.group;
    };
  };
  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing.
    guiPasswordFile = "/run/secrets/common/syncthing";
    settings = {
      gui.user = "${username}";

      # TODO: configure this maybe
      # devices = {
      #   "device1" = {id = "DEVICE-ID-GOES-HERE";};
      #   "device2" = {id = "DEVICE-ID-GOES-HERE";};
      # };
      # folders = {
      #   "Documents" = {
      #     path = "/home/myusername/Documents";
      #     devices = ["device1" "device2"];
      #   };
      #   "Example" = {
      #     path = "/home/myusername/Example";
      #     devices = ["device1"];
      #     ignorePerms = false; # Enable file permission syncing
      #   };
      # };
    };
  };
}
