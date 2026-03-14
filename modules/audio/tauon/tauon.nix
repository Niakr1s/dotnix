{
  config,
  pkgs,
  username,
  flakeDir,
  ...
}: {
  environment.systemPackages = [
    pkgs.unstable.tauon # music player
  ];

  home-manager.users.${username} = {config, ...}: {
    home.file.".local/share/TauonMusicBox/tauon.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.local/share/TauonMusicBox/tauon.conf";
    };
  };
}
