{
  pkgs,
  username,
  flakeDir,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    (mpv.override {
      scripts = [
        mpvScripts.modernz
      ];
    })
  ];

  home-manager.users.${username} =
    { config, ... }:
    {
      xdg.configFile."mpv" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/mpv";
        recursive = true;
      };
    };
}
