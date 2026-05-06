{
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      gnomeExtensions.gsconnect
    ];
    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.gsconnect.extensionUuid
        ];
      };
    };
  };
}
