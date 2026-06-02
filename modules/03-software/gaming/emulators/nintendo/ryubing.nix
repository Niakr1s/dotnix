{
  pkgs,
  lib,
  username,
  flakeDir,
  ...
}:
let
  version = "21.2.0";
  prodKeysFile = "prod.v${version}.keys";
  firmwareUrl = "https://github.com/THZoria/NX_Firmware/releases/download/${version}/Firmware.${version}.zip";

  # Read the contents of the original desktop file provided by the package
  originalDesktopFile = builtins.readFile "${pkgs.ryubing}/share/applications/Ryujinx.desktop";
  # Create a modified version with the new Exec line
  modifiedDesktopFile = pkgs.runCommand "modified-ryujinx-desktop" { } ''
    echo "${originalDesktopFile}" > $out
    sed -i 's|^Exec=\(.*\)|Exec=systemd-inhibit \1|' $out
  '';

  cheats = pkgs.fetchzip {
    name = "ryujinx-cheats";
    url = "https://github.com/HamletDuFromage/switch-cheats-db/releases/download/2026-04-18/contents_complete.zip";
    hash = "sha256-PxsMHOKWcmD6yZX9jxKo2aGtUWg8w1JT3h6sgu1QJSo=";
  };
in
{
  warnings = [
    "Ryujinx firmware: ${firmwareUrl}"
  ];

  environment.systemPackages = with pkgs; [
    ryubing
    nsz
  ];

  home-manager.users.${username} =
    { config, ... }:
    {
      home.file.".local/share/applications/Ryujinx.desktop" = {
        text = builtins.readFile modifiedDesktopFile;
        force = true;
      };

      # for nsz
      home.file.".switch/prod.keys" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/Ryujinx/system/${prodKeysFile}";
      };

      home.file.".config/Ryujinx/system/prod.keys" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/Ryujinx/system/${prodKeysFile}";
      };
      home.file.".config/Ryujinx/Config.json" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/Ryujinx/Config.json";
      };
      home.file.".config/Ryujinx/mods/contents" = {
        source = "${cheats}";
        recursive = true;
        force = true;
      };
    };
}
