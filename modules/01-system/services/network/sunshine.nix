{
  flakeLib,
  pkgs,
  ...
}:
let
  port = 47989;
in
{
  imports = [
    (flakeLib.localhostReverseProxy "sunshine" port)
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
