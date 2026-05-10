{
  username,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.zsh-vi-mode
  ];

  home-manager.users.${username} = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      # Source the zsh-vi-mode plugin
      initContent = ''
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      '';

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
