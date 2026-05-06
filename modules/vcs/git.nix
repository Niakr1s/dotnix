{username, ...}: {
  home-manager.users.${username} = {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Niakr1s";
          email = "pavel2188@gmail.com";
        };
        init.defaultBranch = "main";
      };
    };
  };
}
