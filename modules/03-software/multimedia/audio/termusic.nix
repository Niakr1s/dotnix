{
  pkgs,
  flakeLib,
  ...
}:
{
  environment.systemPackages = [
    pkgs.termusic # music player
  ];

  imports = [
    (flakeLib.mkHomeLink { homePath = ".config/termusic/tui.toml"; })
  ];
}
