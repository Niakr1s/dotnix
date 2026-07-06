{
  pkgs,
  config,
  flakeDir,
  flakeLib,
  hostname,
  username,
  ...
}:
let
  port = 47989;
  guiPort = port + 1;

  sunshinePackage =
    if hostname == "desktop" then pkgs.sunshine.override { cudaSupport = true; } else pkgs.sunshine;
in
{
  imports = [
    (flakeLib.localhostReverseProxy "sunshine" guiPort)
  ];

  services.sunshine = {
    enable = true;
    package = sunshinePackage;
    autoStart = true;
    openFirewall = true;
    capSysAdmin = true;
    settings = {
      port = port; # default is 47989
    };
  };

  home-manager.users.${username} = { config, ... }: {
    home.file.".config/sunshine/sunshine.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/sunshine/sunshine.conf";
    };
  };
}
