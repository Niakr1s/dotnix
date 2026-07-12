{
  pkgs,
  username,
  flakeLib,
  ...
}:
{
  imports = [
    (flakeLib.mkHomeLink { homePath = ".config/yazi/yazi.toml"; })
    (flakeLib.mkHomeLink { homePath = ".config/yazi/keymap.toml"; })
  ];

  home-manager.users.${username} = { config, ... }: {
    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
      plugins = {
        inherit (pkgs.yaziPlugins) mediainfo;
      };
    };
  };
}
