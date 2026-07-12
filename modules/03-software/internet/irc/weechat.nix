{
  pkgs,
  flakeLib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    weechat
  ];

  imports = [
    (flakeLib.mkHomeLink { homePath = ".config/weechat"; })
  ];
}
