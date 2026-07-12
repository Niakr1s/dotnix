{ prodKeysFilePath }:
{
  pkgs,
  flakeLib,
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

  imports = [
    (flakeLib.mkHomeLink {
      homePath = ".config/Ryujinx/system/prod.keys";
      flakePath = prodKeysFilePath;
    })
    (flakeLib.mkHomeLink { homePath = ".config/Ryujinx/Config.json"; })
  ];
}
