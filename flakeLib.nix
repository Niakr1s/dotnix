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
        virtualHosts."http://${name}.localhost" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:${toString port}
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
        allowedTCPPorts = [
          port
        ];
        allowedUDPPorts = [
          port
        ];
      };
    };

  # Creates dirs using systemd.tmpfiles
  createUserDirs =
    {
      dirs,
      user,
      group ? "users",
      mode ? "0755",
    }:
    {
      systemd.user.tmpfiles = {
        enable = true;
        rules = map (dir: "d ${dir} ${mode} ${user} ${group} - -") dirs;
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

  # Note: this must be run from default.nix
  # It will ignore another default.nix in subdirectories to evade inf recursions
  importSubdirsRec =
    path:
    let
      # 1. Recursive scanner that returns a flat list of path types
      scanDir =
        currentPath:
        let
          contents = builtins.readDir currentPath;

          # Process each item in the directory
          collectedPaths = lib.mapAttrsToList (
            name: type:
            let
              itemPath = currentPath + "/${name}";
            in
            if type == "directory" then
              # If it's a directory, recurse into it
              scanDir itemPath
            else if type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix" then
              # If it's a regular .nix file (excluding default.nix), collect it
              [ itemPath ]
            else
              # Skip any other asset file types
              [ ]
          ) contents;
        in
        # Flatten the list of lists for this directory level
        lib.flatten collectedPaths;
    in
    {
      # 2. Return standard NixOS module structure with gathered imports
      imports = scanDir path;
    };

}
