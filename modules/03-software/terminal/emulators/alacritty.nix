{
  pkgs,
  flakeLib,
  ...
}:
{
  environment.systemPackages = [
    pkgs.alacritty
  ];

  imports = [
    (flakeLib.mkHomeLink { homePath = ".config/alacritty"; })
  ];
}
