{
  pkgs,
  username,
  flakeLib,
  ...
}: {
  imports = [
    (flakeLib.mkHomeLink ".config/yazi/yazi.toml")
    (flakeLib.mkHomeLink ".config/yazi/keymap.toml")
  ];

  home-manager.users.${username} = {config, ...}: {
    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
      plugins = {
        inherit (pkgs.yaziPlugins) mediainfo;
      };
    };
  };
}
