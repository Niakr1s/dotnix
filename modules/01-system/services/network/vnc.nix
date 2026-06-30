{
  username,
  ...
}:
let
  port = 5900;
in
{
  home-manager.users.${username} = {
    services.wayvnc = {
      enable = true;
      autoStart = true;
      settings = {
        address = "localhost";
        port = port;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ port ];
  networking.firewall.allowedUDPPorts = [ port ];
}
