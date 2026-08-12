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
    mpv
  ];

  hjem.users.${user} = {
    xdg.config.files = {
      "mpv".source = ./mpv;
    };
  };
}
