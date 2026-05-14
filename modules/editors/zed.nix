{
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username} = {lib, ...}: {
    programs.zed-editor = {
      enable = true;

      # This populates the userSettings "auto_install_extensions"
      extensions = [
        "nix"
        "toml"
        "make"
      ];

      # The extraPackages option includes additional Nixpkgs in the FHS environment,
      # useful for LSP servers (e.g., pkgs.nixd) or
      # optional tools (e.g., pkgs.shellcheck for the Basher LSP)
      extraPackages = with pkgs; [
        direnv
        nixd
        nil
      ];

      userKeymaps = [
        {
          context = "Terminal";
          bindings = {
            "ctrl-`" = "editor::ToggleFocus";
            "ctrl-w h" = "workspace::ActivatePaneLeft";
            "ctrl-w k" = "workspace::ActivatePaneUp";
            "ctrl-w l" = "workspace::ActivatePaneRight";
          };
        }
      ];

      # Everything inside of these brackets are Zed options
      userSettings = {
        # Tell Zed to use direnv and direnv can use a flake.nix environment
        load_direnv = "shell_hook";

        show_edit_predictions = false;
        agent = {
          default_model = {
            provider = "ollama";
            model = "gemma4:e4b";
          };
          model_parameters = [];
        };
        colorize_brackets = true;
        gutter = {
          line_numbers = true;
        };
        vim_mode = true;
        buffer_font_family = ".ZedMono";
        auto_update = false;
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        session = {
          trust_all_worktrees = true;
        };
        ui_font_size = 16.0;
        buffer_font_size = 14.0;
        theme = {
          mode = "system";
          light = "One Light";
          dark = "One Dark";
        };
        lsp = {
          clangd = {
            binary = {
              path_lookup = true;
            };
          };

          rust-analyzer = {
            binary = {
              # path = lib.getExe pkgs.rust-analyzer;
              path_lookup = true;
            };
          };

          nix = {
            binary = {
              path_lookup = true;
            };
          };
        };
      };
    };
  };
}
