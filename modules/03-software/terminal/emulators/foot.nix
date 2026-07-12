{
  pkgs,
  flakeLib,
  ...
}:
{
  environment.systemPackages = [
    pkgs.foot
  ];

  programs.foot = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  imports = [
    (flakeLib.mkHomeLink { homePath = ".config/foot"; })
  ];
}
