# my helper functions
{ lib }:
{
  localhostReverseProxy = name: port: {
    services.caddy = {
      enable = true;
      virtualHosts."http://${name}.localhost" = {
        extraConfig = ''
          reverse_proxy localhost:${toString port}
        '';
      };
    };

    networking.hosts = {
      "127.0.0.1" = [
        "${name}.localhost"
      ];
    };
  };
}
