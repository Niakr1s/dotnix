{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    zapret
  ];

  services.zapret = {
    enable = false;
    configureFirewall = true;
    qnum = 200; # default: 200

    params = [
      "--methodeol"
    ];

    blacklist = [
    ];

    whitelist = [
      "rutracker.org"
      "youtube.com"
    ];
  };
}
