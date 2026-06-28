{
  username,
  ...
}:
{
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      # kdeconnect
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      # kdeconnect
      {
        from = 1714;
        to = 1764;
      }
    ];
  };

  users.users.${username} = {
    extraGroups = [ "avahi" ];
  };

  home-manager.users.${username} = {
    services.kdeconnect = {
      enable = true;
    };
  };
}
