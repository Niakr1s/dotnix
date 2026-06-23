{
  pkgs,
  username,
  flakeDir,
  ...
}: {
  environment.systemPackages = [
    pkgs.termusic # music player
  ];

  home-manager.users.${username} = {config, ...}: {
    home.file.".config/termusic/tui.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/termusic/tui.toml";
    };
  };
}
