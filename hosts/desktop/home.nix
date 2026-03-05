{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  stateVersion,
  hostname,
  username,
  ...
}: let
  unstablePkgs = import nixpkgs-unstable {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };
in {
  imports = [
    ../common/home.nix
    ./wallpaper.nix # You can change wallpaper in this file
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        pkgs.gnomeExtensions.display-configuration-switcher.extensionUuid
      ];
    };
    "org/gnome/shell/extensions/display-configuration-switcher" = {
      display-configuration-switcher-shortcut-next = ["<Alt><Super>p"];
      display-configuration-switcher-shortcut-previous = [];
      display-configuration-switcher-shortcuts-enabled = true;
    };
  };

  # aichat
  programs.aichat = {
    enable = true;

    settings = {
      model = "ollama:gemma3:12b"; # Default model config
      clients = [
        {
          type = "openai-compatible";
          name = "ollama";
          api_base = "http://localhost:11434/v1";
          models = [
            {
              # should correspond to ollama.nix
              name = "gemma3:12b";

              # ollama show _model_, under Capabilities section
              supports_completion = true;
              supports_function_calling = false;
              supports_vision = true;
              supports_reasoning = false;
            }
          ];
        }
      ];
    };
  };

  # mangohud
  programs.mangohud = {
    enable = true;
    settings = {
      fps_limit = [165 30 60];
      vsync = 0; # 0 = adaptive; 1 = off; 2 = mailbox; 3 = on
      time = true;
      time_no_label = true;
      time_format = "%F %T";
      gpu_stats = true;
      gpu_temp = true;
      cpu_stats = true;
      cpu_temp = true;
      fps = true;
      frame_timing = 0;
      font_size = 16;
      text_outline = true;
      width = 0;
      background_alpha = 0.4;

      ### Change toggle keybinds for the hud & logging
      # toggle_hud=Shift_R+F12
      # toggle_hud_position=Shift_R+F11
      # toggle_preset=Shift_R+F10
      # toggle_fps_limit=Shift_R+F1
      # toggle_logging=Shift_L+F2
      # reload_cfg=Shift_L+F4
      # upload_log=Shift_L+F3
      # reset_fps_metrics=Shift_R+f9
      toggle_hud = "Shift_R+F12";
      toggle_fps_limit = "Shift_R+F1";
    };
  };

  # lutris
  programs.lutris = with pkgs; {
    enable = true;
    defaultWinePackage = proton-ge-bin;
    extraPackages = [
      winetricks
      gamescope
      gamemode
      umu-launcher
    ];
    protonPackages = [
      proton-ge-bin
    ];
    winePackages = [
      proton-ge-bin
      # wineWow64Packages.waylandFull # native wayland support (unstable)
    ];
    runners = {
      wine = {
        settings = {
          system = {
            env = {
              PROTON_ENABLE_HDR = 1;
              PROTON_ENABLE_WAYLAND = 1;
            };
            gamescope = false;
            gamescope_hdr = false;
            mangohud = true;
          };
        };
      };
    };
  };
}
