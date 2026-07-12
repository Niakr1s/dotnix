# my helper functions
{
  lib,
}:
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

  # links files from <flakeDir>/home/path/to/file to /home/<user>/path/to/file
  mkHomeLink =
    {
      homePath,

      # should be set as relative path from <flakeDir>,
      # but if is null, it will be set to <flakeDir>/home/<homePath>
      flakePath ? null,
    }:
    let
      flakeRelPath = if flakePath == null then "home/${homePath}" else flakePath;
    in
    { username, flakeDir, ... }: {
      home-manager.users.${username} = { config, ... }: {
        home.file."${homePath}".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/${flakeRelPath}";
      };
    };
}
