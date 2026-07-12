{
  pkgs,
  flakeLib,
  ...
}:
{
  environment.systemPackages = [
    pkgs.wezterm
  ];

  imports = [
    (flakeLib.mkHomeLink { homePath = ".config/wezterm"; })
  ];
}
