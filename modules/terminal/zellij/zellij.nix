{
  config,
  pkgs,
  home-manager,
  username,
  flakeDir,
  ...
}: {
  environment.systemPackages = with pkgs; [
    zellij
    kitty.terminfo
  ];

  home-manager.users.${username} = {config, ...}: {
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

    home.file.".config/zellij/config.kdl" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/zellij/config.kdl";
    };
    # home.file.".config/zellij/layouts" = {
    #   source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/zellij/layouts";
    # };
  };
}
