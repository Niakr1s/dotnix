{
  pkgs,
  username,
  flakeDir,
  ...
}:
{
  environment.systemPackages = [
    pkgs.wezterm
  ];

  home-manager.users.${username} =
    { config, ... }:
    {
      home.file.".config/wezterm" = {
        # TODO: probably move to a separate module, too lazy atm
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/wezterm";
        recursive = true;
      };
    };
}
