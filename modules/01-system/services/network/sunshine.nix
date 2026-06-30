{
  flakeLib,
  pkgs,
  ...
}:
let
  port = 47989;
  guiPort = port + 1;
in
{
  imports = [
    (flakeLib.localhostReverseProxy "sunshine" guiPort)
  ];

  environment.systemPackages = with pkgs; [
    sunshine
  ];

  services.sunshine = {
    enable = true;
    package = pkgs.sunshine.override {
      cudaSupport = false;
    };
    autoStart = true;
    openFirewall = true;
    capSysAdmin = true;
    settings = {
      port = port; # default is 47989
    };
  };
}
