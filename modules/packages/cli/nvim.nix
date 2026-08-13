{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.packages.cli.nvim;
  user = config.modules.core.user;

  myNvim = pkgs.neovim.override {
    configure = {
      customRC = "luafile ~/.config/nvim/init.lua";
      packages.myPlugins.start = with pkgs.vimPlugins; [
        tokyonight-nvim
        nvim-lspconfig
        conform-nvim
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
        plenary-nvim
        nvim-web-devicons
        vim-tmux-navigator
      ];
    };
  };

  baseServers = [
    "nil_ls"
    "lua_ls"
    "bashls"

    "ruff"
    "pyright"

    "ts_ls"

    "jsonls"
    "html"
    "cssls"
    "yamlls"
    "marksman"
    "dockerls"
    "taplo"
    "lemminx"
    "sqlls"
  ];

  heavyServers = [
    "clangd"
    "kotlin_language_server"
    "rust_analyzer"
    "gopls"
    "omnisharp"
    "jdtls"
    "phpactor"
    "crystalline"
  ];


  lspServers = baseServers ++ heavyServers;

  lspList = lib.concatMapStringsSep ",\n    " (s: ''"${s}"'') lspServers;

  lspLua = ''
    vim.lsp.enable({
      ${lspList},
    })
  '';
in
{
  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    environment.systemPackages = [
      myNvim
    ];

    hjem.users.${user} = {
      xdg.config.files = {
        "nvim/init.lua".text = ''
          require('config')
          require('lsp')
        '';
        "nvim/lua/config.lua".source = ./nvim/config.lua;
        "nvim/lua/lsp.lua".text = lspLua;
      };
    };
  };
}
