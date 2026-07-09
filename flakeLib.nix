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

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        port
      ];
      allowedUDPPorts = [
        port
      ];
    };
  };

  # Creates dirs using systemd.tmpfiles
  createDirs =
    {
      dirs,
      user ? "root",
      group ? "root",
      mode ? "0755",
    }:
    {
      systemd.tmpfiles.rules = map (dir: "d ${dir} ${mode} ${user} ${group} - -") dirs;
    };
}
