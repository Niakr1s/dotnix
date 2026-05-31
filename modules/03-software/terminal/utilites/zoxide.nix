{username, ...}: {
  home-manager.users.${username} = {config, ...}: {
    programs.zoxide = {
      enable = true;
      enableBashIntegration= true;
      enableZshIntegration = true;
    };
  };
}
