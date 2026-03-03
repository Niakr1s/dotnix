{ config, lib, pkgs, nixpkgs-unstable, ... }:
let
  unstablePkgs = import nixpkgs-unstable {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };
in

{
  home.username = "nea";
  home.homeDirectory = "/home/nea";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
  ];

  programs.zsh = {
    enable = true;

    shellAliases = {
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Niakr1s";
        email = "pavel2188@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.foot = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/nea/.dotnix/config/nvim";
    recursive = true;
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        accent-color = "blue";
	color-scheme = "prefer-dark";
      };

      "org/gnome/shell" = {
        last-selected-power-profile = "perfomance";
        disable-user-extensions = false; # Optionally disable user extensions entirely
        enabled-extensions = [
          pkgs.gnomeExtensions.blur-my-shell.extensionUuid
          pkgs.gnomeExtensions.just-perfection.extensionUuid
	];
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-schedule-from = 20.0;
        night-light-schedule-to = 7.0;
	night-light-temperature = 3700;
      };

      # Configure individual extensions
      "org/gnome/shell/extensions/blur-my-shell" = {
        brightness = 0.75;
        noise-amount = 0;
      };
    };
  };
}
