{
  pkgs,
  username,
  flakeLib,
  ...
}:
{
  imports = [
    (flakeLib.mkHomeLink {
      homePath = ".config/celluloid";
      flakePath = "home/.config/mpv";
    })
  ];

  home-manager.users.${username} = { config, ... }: {
    home.packages = with pkgs; [ celluloid ];

    dconf.settings = {
      "io/github/celluloid-player/celluloid" = {
        mpv-input-config-enable = false; # it won't work with touchpad, so I don't need it
        mpv-input-config-file = "file:///home/${username}/.config/mpv/input.conf";
        mpv-config-enable = true;
        mpv-config-file = "file:///home/${username}/.config/mpv/mpv.conf";
        csd-enable = true;
      };
    };
  };
}
