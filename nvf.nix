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
          blink-indent.enable = true;
          indent-blankline.enable = true;

          # Fun
          cellular-automaton.enable = false;
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
      };
    };
  };
}
