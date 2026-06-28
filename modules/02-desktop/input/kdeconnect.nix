{
  username,
  ...
}:
{
  users.users.${username} = {
    extraGroups = [ "avahi" ];
  };

  home-manager.users.${username} = {
    services.kdeconnect = {
      enable = true;
    };
  };
}
