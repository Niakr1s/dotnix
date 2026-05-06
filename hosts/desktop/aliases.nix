{username, ...}: {
  home-manager.users.${username} = {
    home.shellAliases = {
      hdd1 = "cd /data/hdd1";
      ssd = "cd /data/ssd";
    };
  };
}
