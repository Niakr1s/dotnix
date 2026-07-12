{
  pkgs,
  username,
  flakeLib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    zellij
    kitty.terminfo
  ];

  imports = [
    (flakeLib.mkHomeLink { homePath = ".config/zellij/layouts/nix.kdl"; })
    (flakeLib.mkHomeLink { homePath = ".config/zellij/config.kdl"; })
  ];

  home-manager.users.${username} =
    { config, ... }:
    {
      programs.zellij = {
        enable = true;
      };

      home.shellAliases = {
        ze = "zellij -l welcome";
      };

      programs.zsh.siteFunctions = {
        yazi = ''
          if [ -n "$ZELLIJ" ]; then
            TERM=xterm-kitty command yazi "$@"
          else
            command yazi "$@"
          fi
        '';
      };
    };
}
