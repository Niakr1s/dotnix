{
  pkgs,
  flakeLib,
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

  imports = [
    (flakeLib.mkHomeLink { homePath = ".config/mpv"; })
  ];
}
