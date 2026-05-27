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
        catppuccin-nvim
        conform-nvim
        nvim-autopairs
        comment-nvim
        lualine-nvim
        blink-cmp
        todo-comments-nvim
        trouble-nvim
        undotree
      ];

      extraPackages = with pkgs; [
        # formatters
        ruff
        stylua
        alejandra

        # language servers
        pyright
        lua-language-server
        nil
      ];
    };

    home.file.".config/nvim/init.lua" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/nvim/init.lua";
    };
  };
}
