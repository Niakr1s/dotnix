{
  config,
  username,
  ...
}:
{
  home-manager.users.${username} = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      shellAliases = config.environment.shellAliases;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
        ];
        theme = "maran";
      };
    };
  };
}
