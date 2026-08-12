{ lib, ... }:
let
  # 1. Получаем список всех элементов в корневой директории
  rootDirContents = builtins.readDir ./.;

  # 2. Фильтруем, оставляя только папки первого уровня
  subDirs = lib.filterAttrs (name: type: type == "directory") rootDirContents;

  # 3. Функция, которая читает содержимое ОДНОЙ подпапки и собирает её .nix файлы
  findNixInSubdir = dirName:
    let
      subdirPath = ./${dirName};
      subdirContents = builtins.readDir subdirPath;
    in
    lib.mapAttrsToList (name: _: subdirPath + "/${name}") (
      lib.filterAttrs (name: type:
        type == "directory" || type == "regular" && lib.hasSuffix ".nix" name
      ) subdirContents
    );
in
{
  # 4. Собираем файлы из всех подпапок в один плоский список
  imports = lib.flatten (lib.mapAttrsToList (name: _: findNixInSubdir name) subDirs);
}

