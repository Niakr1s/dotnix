{
  flakeLib,
  pkgs,
  ...
}:
{
  imports = [
    (flakeLib.localhostReverseProxy "v2raya" 2017)
  ];

  # VPN
  services.v2raya = {
    enable = true;
  };
}
