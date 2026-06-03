{
  pkgs,
  username,
  ...
}:
{
  environment.systemPackages = [
    pkgs.gnome-text-editor # gui text editor
  ];

  home-manager.users.${username} =
    { config, lib, ... }:
    {
      dconf = {
        enable = true;
        settings = {
          "org/gnome/TextEditor" = {
            highlight-current-line = true;
            indent-style = "space";
            restore-session = false;
            show-line-numbers = true;
            show-map = false;
            show-right-margin = false;
            style-scheme = "classic-dark";
            tab-width = lib.hm.gvariant.mkUint32 2;
            indent-width = -1;
            use-system-font = true;
            wrap-text = true;
          };
        };
      };
    };
}
