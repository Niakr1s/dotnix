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
          "file:///data/ssd ssd"
          "file:///data/hdd1 hdd1"
          "file:///data/hdd4 hdd4"
          "file:///data/hdd20 hdd20"
        ];
      };
    };
  };
}
