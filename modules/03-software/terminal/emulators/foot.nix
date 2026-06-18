{
  pkgs,
  username,
  flakeDir,
  ...
}:
{
  environment.systemPackages = [
    pkgs.foot
  ];

  programs.foot = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  home-manager.users.${username} =
    { config, ... }:
    {
      home.file.".config/foot" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/foot";
        recursive = true;
      };
    };
}
