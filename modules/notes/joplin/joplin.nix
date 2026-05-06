{username, ...}: {
  home-manager.users.${username} = {config, ...}: {
    programs.joplin-desktop = {
      enable = true;
      sync = {
        target = "dropbox";
        interval = "10m";
      };
    };
  };
}
