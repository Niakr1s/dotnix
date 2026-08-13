{
  config,
  lib,
  pkgs,
  hjem,
  ...
}:
let
  user = config.modules.core.user;
in
{
  environment.systemPackages = with pkgs; [
    mediainfo
  ];

  hjem.users.${user} = {
    xdg.config.files = {
      "yazi/plugins/mediainfo.yazi".source = pkgs.yaziPlugins.mediainfo;
    };
  };

  programs.yazi = {
    enable = true;
    package = pkgs.yazi.override { _7zz = pkgs._7zz-rar; };
  };
}
