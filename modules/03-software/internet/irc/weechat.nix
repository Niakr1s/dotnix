{
  pkgs,
  flakeLib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    weechat
  ];

  imports = [
    (flakeLib.mkHomeLink ".config/weechat")
  ];
}
