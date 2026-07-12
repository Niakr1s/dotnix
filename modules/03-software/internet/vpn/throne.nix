{
  username,
  flakeDir,
  ...
}:
{
  programs.throne = {
    enable = true;
    tunMode = {
      enable = true;
    };
  };

  home-manager.users.${username} = { config, ... }: {
    home.file.".config/Throne/config/route_profiles/Default".source =
      config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/Throne/config/route_profiles/Default";
  };
}
