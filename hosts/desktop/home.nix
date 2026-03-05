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

  # HOME SYMLINKS

  xdg.configFile."MangoHud" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotnix/config/MangoHud";
    recursive = true;
  };

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

  # lutris
  programs.lutris = with pkgs; {
    enable = true;
    defaultWinePackage = proton-ge-bin;
    extraPackages = [
      mangohud
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
