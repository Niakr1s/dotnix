{
  pkgs,
  username,
  flakeDir,
  ...
}: {
  home-manager.users.${username} = {config, ...}: {
    programs.neovim = {
      enable = true;

      defaultEditor = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      withNodeJs = true;
      withPython3 = true;
      withRuby = true;

      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        telescope-nvim
        comment-nvim
        nvim-surround
        yazi-nvim
        blink-cmp
        gitsigns-nvim
        which-key-nvim
        codecompanion-nvim
        plenary-nvim # lua functions you don't want to write

        # themes
        tokyonight-nvim
        catppuccin-nvim
        nord-nvim
        gruvbox-material-nvim
        oxocarbon-nvim
      ];

      extraPackages = with pkgs; [
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

        file
        ripgrep
        curl
      ];
    };

    home.file.".config/nvim/init.lua" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/nvim/init.lua";
    };
  };
}
