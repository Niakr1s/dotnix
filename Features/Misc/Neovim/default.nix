{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.neovim;
  user = config.core.user;
  headless = config.core.headless;
  inherit (lib) optionals;

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
    "nil"
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

  baseServersPkgs = with pkgs; [
    nil
    lua-language-server
    bash-language-server
    ruff
    pyright
    typescript-language-server
    vscode-langservers-extracted # предоставляет jsonls, html, cssls
    yaml-language-server
    marksman
    docker-language-server
    taplo
    lemminx
    sqls
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

  heavyServersPkgs = with pkgs; [
    clang-tools
    kotlin-language-server
    rust-analyzer
    gopls
    omnisharp-roslyn
    jdt-language-server
    phpactor
    crystalline
  ];

  lspServers = baseServers ++ lib.optionals (!headless) heavyServers;

  lspList = lib.concatMapStringsSep ",\n    " (s: ''"${s}"'') lspServers;

  lspLua = ''
    vim.lsp.enable({
      ${lspList},
    })
  '';
in
{
  options.features.neovim = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Neovim Configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    environment.systemPackages =
      [ myNvim ]
      ++ baseServersPkgs
      ++ optionals (!headless) heavyServersPkgs;

    hjem.users.${user} = {
      xdg.config.files = {
        "nvim/init.lua".text = ''
          require('config')
          require('lsp')
        '';
        "nvim/lua/config.lua".source = ./config.lua;
        "nvim/lua/lsp.lua".text = lspLua;
      };
    };
  };
}
