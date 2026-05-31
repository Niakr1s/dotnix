{
  pkgs,
  username,
  ...
}:
{
  environment.systemPackages = [
    pkgs.nautilus # GNOME file manager
  ];

  home-manager.users.${username} =
    { config, ... }:
    {
      dconf = {
        enable = true;
        settings = {
          "org/gtk/gtk4/settings/file-chooser" = {
            sort-directories-first = true;
            show-hidden = false;
          };

          "org/gnome/nautilus/preferences" = {
            default-folder-viewer = "list-view";
            show-create-link = true;
            show-delete-permanently = true;
            date-time-format = "detailed";
          };
          "org/gnome/nautilus/list-view" = {
            use-tree-view = true;
          };
          "org/gnome/nautilus/icon-view" = {
            # captions = ["none" "none" "none"];
            # captions = ["owner" "group" "permissions"];
            captions = [
              "size"
              "date_modified"
              "none"
            ];
          };
        };
      };
    };
}
