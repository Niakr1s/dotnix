{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.packages.cli.nvim;

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
        # vim-tmux-navigator # doesn't work with kitty
        vim-kitty-navigator
      ];
    };
  };

  formatters = with pkgs; [
    # --- baseServers Languages ---
    alejandra # Nix (nixd)
    stylua # Lua (lua_ls)
    shfmt # Bash / Shell (bashls)
    ruff # Python Lint/Format (ruff/pyright)
    biome # JavaScript / TypeScript / JSON / HTML / CSS (ts_ls, jsonls, html, cssls)
    yamlfmt # YAML (yamlls)
    deno # Markdown (marksman) - Multi-language block fallback
    dockerfile-language-server # Dockerfile (dockerls) - (Often formats natively or via 'injected')
    taplo # TOML (taplo)
    lemminx # XML (lemminx) - Formats natively via its own LSP binaries
    sleek # SQL (sqlls) - Modern CLI SQL formatter

    # --- heavyServers Languages ---
    clang-tools # C / C++ (clangd) - Provides 'clang-format'
    ktlint # Kotlin (kotlin_language_server)
    rustfmt # Rust (rust_analyzer) - Usually bundled, explicit here
    gofumpt # Go (gopls) - Stricter standard formatter
    csharpier # C# (omnisharp)
    google-java-format # Java (jdtls)
    crystal # Crystal (crystalline) - Includes the native
  ];

  baseServers = [
    "nixd"
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
in {
  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    environment.systemPackages =
      [
        myNvim
      ]
      ++ formatters;

    home = {
      ".config/nvim/init.lua".text = ''
        require('config')
        require('lsp')
      '';
      ".config/nvim/lua/lsp.lua".text = lspLua;
    };
  };
}
