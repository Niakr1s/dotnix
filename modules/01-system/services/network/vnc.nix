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
        address = "127.0.0.1";
        port = port;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ port ];
  networking.firewall.allowedUDPPorts = [ port ];
}
