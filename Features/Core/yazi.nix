{
  config,
  lib,
  pkgs,
  hjem,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    mediainfo
  ];

  programs.yazi = {
    enable = true;
    package = pkgs.yazi.override { _7zz = pkgs._7zz-rar; };
  };
}
