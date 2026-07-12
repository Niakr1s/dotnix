{
  pkgs,
  flakeLib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    w3m
  ];

  imports = [
    # (flakeLib.mkHomeLink { homePath = ".w3m/keymap"; })
    (flakeLib.mkHomeLink { homePath = ".w3m/config"; })
  ];
}
