{
  inputs,
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  disko,
  hostname,
  username,
  ...
}: {
  home-manager.users.${username} = {
    gtk = {
      enable = true;
      gtk3 = {
        enable = true;
        bookmarks = [
          "file:/// root"
          "file:///srv/torrents torrents"
          "file:///home/${username}/Music Music"
          "file:///home/${username}/Videos Videos"
          "file:///home/${username}/Pictures Pictures"
          "file:///home/${username}/Documents Documents"
          "file:///home/${username}/Downloads Downloads"
        ];
      };
    };
  };
}
