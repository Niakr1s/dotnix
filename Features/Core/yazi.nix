{
  config,
  lib,
  pkgs,
  hjem,
  ...
}:
let
  user = config.core.user;
in
{
  environment.systemPackages = with pkgs; [
    mediainfo
  ];

  hjem.users.${user} = {
    enable = true;
    xdg.config.files = {
      "yazi/yazi.toml".source = ./yazi/yazi.toml;
      "yazi/keymap.toml".source = ./yazi/keymap.toml;
      "yazi/plugins/mediainfo.yazi".source = pkgs.yaziPlugins.mediainfo;
    };
  };

  programs.yazi = {
    enable = true;

    package = pkgs.yazi.override { _7zz = pkgs._7zz-rar; };
  };
}
