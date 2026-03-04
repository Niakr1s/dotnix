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

        clipboard = {
          enable = true;
          providers.wl-copy.enable = true;
        };

        options = {
          autoindent = true;
        };

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
          transparent = false;
        };

        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };

        lsp = {
          # This must be enabled for the language modules to hook into
          # the LSP API.
          enable = true;

          formatOnSave = true;
          lspkind.enable = false;
          lightbulb.enable = true;
          lspsaga.enable = false;
          trouble.enable = true;
          lspSignature.enable = false; # conflicts with blink in maximal
          otter-nvim.enable = true;
          nvim-docs-view.enable = true;
          harper-ls.enable = true;
        };

        # This section does not include a comprehensive list of available language modules.
        # To list all available language module options, please visit the nvf manual.
        languages = {
          enableFormat = true;
          enableTreesitter = true;
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
          arduino.enable = false;
          assembly.enable = false;
          astro.enable = false;
          nu.enable = false;
          csharp.enable = true;
          julia.enable = false;
          vala.enable = false;
          scala.enable = false;
          r.enable = false;
          gleam.enable = false;
          glsl.enable = false;
          dart.enable = false;
          ocaml.enable = false;
          elixir.enable = false;
          haskell.enable = false;
          hcl.enable = false;
          ruby.enable = false;
          fsharp.enable = false;
          just.enable = false;
          make.enable = true;
          qml.enable = false;
          jinja.enable = false;
          tailwind.enable = false;
          svelte.enable = false;
          tera.enable = false;

          # Nim LSP is broken on Darwin and therefore
          # should be disabled by default. Users may still enable
          # `vim.languages.vim` to enable it, this does not restrict
          # that.
          # See: <https://github.com/PMunch/nimlsp/issues/178#issue-2128106096>
          nim.enable = true;
        };

        visuals = {
          nvim-scrollbar.enable = true;
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          cinnamon-nvim.enable = true;
          fidget-nvim.enable = true;

          highlight-undo.enable = true;
          indent-blankline.enable = true;
          rainbow-delimiters.enable = true;
        };

        autopairs.nvim-autopairs.enable = false;

        # nvf provides various autocomplete options. The tried and tested nvim-cmp
        # is enabled in default package, because it does not trigger a build. We
        # enable blink-cmp in maximal because it needs to build its rust fuzzy
        # matcher library.
        autocomplete = {
          nvim-cmp.enable = true;
          blink-cmp.enable = false;
        };

        snippets.luasnip.enable = true;

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

        telescope.enable = true;

        git = {
          enable = true;
          gitsigns.enable = true;
          gitsigns.codeActions.enable = false; # throws an annoying debug message
          neogit.enable = true;
        };

        minimap = {
          minimap-vim.enable = false;
          codewindow.enable = true; # lighter, faster, and uses lua for configuration
        };

        dashboard = {
          dashboard-nvim.enable = false;
          alpha.enable = true;
        };

        notify = {
          nvim-notify.enable = true;
        };

        projects = {
          project-nvim.enable = true;
        };

        utility = {
          ccc.enable = false;
          diffview-nvim.enable = true;
          direnv.enable = true;
          icon-picker.enable = true;
          motion = {
            flash-nvim.enable = true;
          };
          surround = {
            enable = true;
            useVendoredKeybindings = true; # use alternative keybindings "gzz"
          };
          sleuth.enable = true;
          undotree.enable = true;
          nvim-biscuits.enable = true;
          yazi-nvim.enable = true;
          grug-far-nvim.enable = true;
        };
        notes = {
          neorg.enable = false;
          orgmode.enable = false;
          mind-nvim.enable = true;
          todo-comments.enable = true;
        };

        terminal = {
          toggleterm = {
            enable = true;
            lazygit.enable = true;
          };
        };

        ui = {
          borders.enable = true;
          colorizer.enable = true;
          modes-nvim.enable = false; # the theme looks terrible with catppuccin
          illuminate.enable = true;
          breadcrumbs = {
            enable = true;
            navbuddy.enable = true;
          };
          smartcolumn = {
            enable = true;
            setupOpts.custom_colorcolumn = {
              # this is a freeform module, it's `buftype = int;` for configuring column position
              nix = "110";
              ruby = "120";
              java = "130";
              go = ["90" "130"];
            };
          };
          fastaction.enable = true;
        };

        assistant = {
          chatgpt.enable = false;
          copilot = {
            enable = false;
            cmp.enable = true;
          };
          codecompanion-nvim.enable = false;
          avante-nvim.enable = true;
        };

        session = {
          nvim-session-manager.enable = false;
        };

        gestures = {
          gesture-nvim.enable = false;
        };

        comments = {
          comment-nvim.enable = true;
        };
      };
    };
  };
}
