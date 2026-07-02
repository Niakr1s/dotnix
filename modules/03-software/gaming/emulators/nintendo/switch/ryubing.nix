{ prodKeysFilePath }:
{
  pkgs,
  username,
  flakeDir,
  ...
}:
let
  cheats = pkgs.fetchzip {
    name = "ryujinx-cheats";
    url = "https://github.com/HamletDuFromage/switch-cheats-db/releases/download/2026-04-18/contents_complete.zip";
    hash = "sha256-PxsMHOKWcmD6yZX9jxKo2aGtUWg8w1JT3h6sgu1QJSo=";
  };
in
{
  warnings = [
    "Ryujinx cheats are available under ${cheats}, consider copying them under ~/.config/Ryujinx/mods/contents"
  ];

  environment.systemPackages = with pkgs; [
    ryubing
  ];

  home-manager.users.${username} =
    { config, ... }:
    {
      home.file.".config/Ryujinx/system/prod.keys" = {
        source = config.lib.file.mkOutOfStoreSymlink prodKeysFilePath;
      };
      home.file.".config/Ryujinx/Config.json" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/Ryujinx/Config.json";
      };

      # this takes too long
      # home.file.".config/Ryujinx/mods/contents" = {
      #   source = "${cheats}";
      #   recursive = true;
      #   force = true;
      # };
    };
}
