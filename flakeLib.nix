# my helper functions
{
  lib,
}:
{
  localhostReverseProxy =
    name: port:
    {
      insecureTLS ? false,
    }:
    {
      services.caddy = {
        enable = true;
        virtualHosts."${name}.localhost" = {
          extraConfig = ''
            reverse_proxy localhost:${toString port}
            ${
              if insecureTLS then
                ''
                  {
                    transport http {
                      tls_insecure_skip_verify
                    }
                  }''
              else
                ""
            }
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

  importSubdirs =
    path:
    let
      # 1. Получаем список всех элементов в корневой директории
      rootDirContents = builtins.readDir path;

      # 2. Фильтруем, оставляя только папки первого уровня
      subDirs = lib.filterAttrs (name: type: type == "directory") rootDirContents;

      # 3. Функция, которая читает содержимое ОДНОЙ подпапки и собирает её .nix файлы
      findNixInSubdir =
        dirName:
        let
          subdirPath = path + "/${dirName}";
          subdirContents = builtins.readDir subdirPath;
        in
        lib.mapAttrsToList (name: _: subdirPath + "/${name}") (
          lib.filterAttrs (
            name: type:
            (type == "regular" && lib.hasSuffix ".nix" name)
            ||
              # Safer check: only import subdirs if they actually have a default.nix
              (type == "directory" && builtins.pathExists (subdirPath + "/${name}/default.nix"))
          ) subdirContents
        );
    in
    {
      # 4. Собираем файлы из всех подпапок в один плоский список
      imports = lib.flatten (lib.mapAttrsToList (name: _: findNixInSubdir name) subDirs);
    };

}
