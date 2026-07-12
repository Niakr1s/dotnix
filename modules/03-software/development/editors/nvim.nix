{
  pkgs,
  username,
  flakeLib,
  ...
}:
{
  imports = [
    (flakeLib.mkHomeLink ".config/nvim/lua")
  ];

  home-manager.users.${username} = { config, ... }: {
    programs.neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      withNodeJs = true;
      withPython3 = true;
      withRuby = true;

      initLua = "require('nvim')";

      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        nvim-treesitter-textobjects
        telescope-nvim
        comment-nvim
        nvim-surround
        yazi-nvim
        blink-cmp
        gitsigns-nvim
        which-key-nvim
        codecompanion-nvim
        plenary-nvim # lua functions you don't want to write
        nvim-web-devicons # nerd font icons
        vim-tmux-navigator

        # themes
        tokyonight-nvim
        catppuccin-nvim
        nord-nvim
        gruvbox-material-nvim
        oxocarbon-nvim
      ];

      extraPackages = with pkgs; [
        tree-sitter
        yazi
        ruff
        ruby-lsp
        bash-language-server
        rust-analyzer
        gopls
        clang-tools
        csharp-ls
        nil
        lua-language-server
        vscode-langservers-extracted
        vtsls
        zls
        yaml-language-server
        marksman
        phpactor
        crystalline

        file
        ripgrep
        curl
      ];
    };
  };
}
