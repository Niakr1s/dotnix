{ username, ... }:
{
  home-manager.users.${username} =
    { config, ... }:
    {
      programs.obsidian = {
        enable = true;
        cli.enable = true;
      };
    };
}
