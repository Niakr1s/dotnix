{
  pkgs,
  username,
  flakeDir,
  ...
}: {
  environment.systemPackages = with pkgs; [
    retroarch-full
  ];

  home-manager.users.${username} = {config, ...}: {
    home.file.".config/retroarch/retroarch.cfg" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/retroarch/retroarch.cfg";
    };
  };
}
