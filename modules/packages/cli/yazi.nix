{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    yazi
    mediainfo
  ];

  home = {
    ".config/yazi/plugins/mediainfo.yazi".source = pkgs.yaziPlugins.mediainfo;
  };

  programs.yazi = {
    enable = true;
    package = pkgs.yazi.override { _7zz = pkgs._7zz-rar; };
  };
}
