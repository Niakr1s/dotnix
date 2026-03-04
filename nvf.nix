{
  cofig,
  pkgs,
  inputs,
  ...
}: {
  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
        lineNumberMode = "number";

        keymaps = [
          {
            key = "<leader>n";
            mode = "n";
            silent = true;
            action = ":Neotree toggle<CR>";
            # action = ":NvimTreeToggle<CR>";
            desc = "Toggle Explorer";
          }
        ];

        clipboard = {
          enable = true;
          providers.wl-copy.enable = true;
        };

        # options = {
        #   tabstop = 2;
        #   shiftwidth = 2;
        #   expandtab = true;
        #   autoindent = true;
        #   smartindent = true;
        # };

        statusline = {
          lualine = {
            enable = true;
            theme = "catppuccin";
          };
        };

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
          transparent = true;
        };

        # debugger = {
        #   nvim-dap = {
        #     enable = true;
        #     ui.enable = true;
        #   };
        # };

        lsp = {
          # This must be enabled for the language modules to hook into
          # the LSP API.
          enable = true;
          formatOnSave = true;

          # lspkind.enable = false;
          lightbulb.enable = true;
          # lspsaga.enable = false;
          trouble.enable = true;
          # lspSignature.enable = false; # conflicts with blink in maximal
          # otter-nvim.enable = true; # Otter.nvim provides lsp features, including code completion, for code embedded in other documents
          # nvim-docs-view.enable = true; # A neovim plugin to display lsp hover documentation in a side panel.
          # harper-ls.enable = true; # grammar chekcer
        };

        # This section does not include a comprehensive list of available language modules.
        # To list all available language module options, please visit the nvf manual.
        languages = {
          enableFormat = true;
          # enableTreesitter = true; # IMPORTANT: this breaks identation
          enableExtraDiagnostics = true;

          # Languages that will be supported in default and maximal configurations.
          nix.enable = true;
          markdown.enable = true;

          # Languages that are enabled in the maximal configuration.
          bash.enable = true;
          clang.enable = true;
          cmake.enable = true;
          css.enable = true;
          html.enable = true;
          json.enable = true;
          sql.enable = true;
          java.enable = true;
          kotlin.enable = true;
          ts.enable = true;
          go.enable = true;
          lua.enable = true;
          zig.enable = true;
          python.enable = true;
          typst.enable = true;
          rust = {
            enable = true;
            extensions.crates-nvim.enable = true;
          };
          toml.enable = true;
          xml.enable = true;

          # Language modules that are not as common.
          # arduino.enable = false;
          # assembly.enable = false;
          # astro.enable = false;
          # nu.enable = false;
          # csharp.enable = true;
          # julia.enable = false;
          # vala.enable = false;
          # scala.enable = false;
          # r.enable = false;
          # gleam.enable = false;
          # glsl.enable = false;
          # dart.enable = false;
          # ocaml.enable = false;
          # elixir.enable = false;
          # haskell.enable = false;
          # hcl.enable = false;
          # ruby.enable = false;
          # fsharp.enable = false;
          # just.enable = false;
          # make.enable = true;
          # qml.enable = false;
          # jinja.enable = false;
          # tailwind.enable = false;
          # svelte.enable = false;
          # tera.enable = false;

          # Nim LSP is broken on Darwin and therefore
          # should be disabled by default. Users may still enable
          # `vim.languages.vim` to enable it, this does not restrict
          # that.
          # See: <https://github.com/PMunch/nimlsp/issues/178#issue-2128106096>
          # nim.enable = true;
        };

        visuals = {
          nvim-scrollbar.enable = true;
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true; # Highlight words and lines on the cursor for Neovim
          cinnamon-nvim.enable = true; # Smooth scrolling
          fidget-nvim.enable = true; # Extensible UI for Neovim notifications and LSP progress messages.

          highlight-undo.enable = true; # Highlight changed text after any action not in insert mode which modifies the current buffer.
          indent-blankline.enable = true; # This plugin adds indentation guides to Neovim.
          rainbow-delimiters.enable = true; # This Neovim plugin provides alternating syntax highlighting (“rainbow parentheses”) for Neovim
        };

        autopairs.nvim-autopairs.enable = true;

        # nvf provides various autocomplete options. The tried and tested nvim-cmp
        # is enabled in default package, because it does not trigger a build. We
        # enable blink-cmp in maximal because it needs to build its rust fuzzy
        # matcher library.
        autocomplete = {
          nvim-cmp.enable = true;
          blink-cmp.enable = false;
        };

        # snippets.luasnip.enable = true;

        filetree = {
          neo-tree = {
            enable = true;
          };
        };

        treesitter = {
          context.enable = true;
          indent.enable = true;
        };

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = false;
        };

        telescope.enable = true; # find files and text

        git = {
          enable = true;
          gitsigns.enable = true;
          gitsigns.codeActions.enable = false; # throws an annoying debug message
          neogit.enable = true;
        };

        # minimap = {
        #   minimap-vim.enable = false;
        #   codewindow.enable = true; # lighter, faster, and uses lua for configuration
        # };

        # dashboard = {
        #   dashboard-nvim.enable = false; # start screen at startup
        #   alpha.enable = true;
        # };

        notify = {
          nvim-notify.enable = true;
        };

        projects = {
          project-nvim.enable = true; # project.nvim is an all in one neovim plugin written in lua that provides superior project management.
        };

        utility = {
          ccc.enable = false; # create color code
          diffview-nvim.enable = true; # Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
          # direnv.enable = true; # A neovim wrapper around direnv, in pure lua.
          icon-picker.enable = true; # icon-picker.nvim is a Neovim plugin that helps you pick 𝑨𝕃𝚻 Font Characters, Symbols Σ, Nerd Font Icons  & Emojis ✨
          motion = {
            flash-nvim.enable = true; # lets you navigate your code with search labels, enhanced character motions, and Treesitter integration.
          };
          surround = {
            enable = true;
            useVendoredKeybindings = true; # use alternative keybindings "gzz"
          };
          sleuth.enable = true; # indentation computation
          undotree.enable = true; # Edit history visualizer
          # nvim-biscuits.enable = true; # WARN: Conflicts with treesitter! usually at the end of a closing tag/bracket/parenthesis/etc
          yazi-nvim.enable = true; # Yazi integration
          grug-far-nvim.enable = true; # Find And Replace plugin for neovim
        };

        notes = {
          neorg.enable = false;
          orgmode.enable = false;
          mind-nvim.enable = false; # deprecated
          todo-comments.enable = true; # highlight and search todo comments
        };

        # terminal = {
        #   toggleterm = {
        #     enable = true;
        #     lazygit.enable = true;
        #   };
        # };

        ui = {
          # borders.enable = true; # Adds borders to all windows
          colorizer.enable = true; # A high-performance color highlighter for Neovim which has no external dependencies!
          # illuminate.enable = true;
          breadcrumbs = {
            enable = true;
            navbuddy.enable = true;
          };
          smartcolumn = {
            enable = false;
            setupOpts.custom_colorcolumn = {
              # this is a freeform module, it's `buftype = int;` for configuring column position
              nix = "110";
              ruby = "120";
              java = "130";
              go = ["90" "130"];
            };
          };
          fastaction.enable = true; # Whether to enable overriding vim.ui.select with fastaction.nvim.
        };

        assistant = {
          # chatgpt.enable = false;
          # copilot = {
          #   enable = false;
          #   cmp.enable = true;
          # };
          # codecompanion-nvim.enable = false;
          avante-nvim.enable = false;
        };

        # session = {
        #   nvim-session-manager.enable = false;
        # };

        # gestures = {
        #   gesture-nvim.enable = false; # mouse gestures
        # };

        comments = {
          comment-nvim.enable = true; # comments with gcc
        };
      };
    };
  };
}
