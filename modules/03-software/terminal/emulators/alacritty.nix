{
  pkgs,
  username,
  flakeDir,
  ...
}:
{
  environment.systemPackages = [
    pkgs.alacritty
  ];

  home-manager.users.${username} =
    { config, ... }:
    {
      home.file.".config/alacritty" = {
        # TODO: probably move to a separate module, too lazy atm
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/alacritty";
        recursive = true;
      };
    };
}
