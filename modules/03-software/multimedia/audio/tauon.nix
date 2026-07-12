{
  pkgs,
  flakeLib,
  ...
}:
{
  environment.systemPackages = [
    pkgs.tauon # music player
  ];

  imports = [
    (flakeLib.mkHomeLink { homePath = ".local/share/TauonMusicBox/tauon.conf"; })
  ];
}
