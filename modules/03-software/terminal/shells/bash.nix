{
  config,
  username,
  ...
}:
{
  home-manager.users.${username} = {
    programs.bash = {
      enable = true;
      shellAliases = config.environment.shellAliases;
    };
  };
}
