{
  config,
  pkgs,
  lib,
  home-manager,
  username,
  flakeDir,
  ...
}: {
  environment.systemPackages = with pkgs; [
    zellij
    kitty.terminfo
  ];

  home-manager.users.${username} = {config, ...}: let
    mkLayout = layoutFileName: {
      ".config/zellij/layouts/${layoutFileName}" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/zellij/layouts/${layoutFileName}";
      };
    };
    layouts = [
      (mkLayout "nix.kdl")
    ];
  in {
    programs.zellij = {
      enable = true;

      # this autostarts zellij on zsh start, I don't want it
      # enableZshIntegration = true;
      # enableFishIntegration = true;
      # enableBashIntegration = true;
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

    home.file =
      (lib.foldl lib.recursiveUpdate {} layouts)
      // {
        ".config/zellij/config.kdl" = {
          source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/zellij/config.kdl";
        };
      };
  };
}
