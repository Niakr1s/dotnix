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
  home.stateVersion = "${stateVersion}";

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
  ];

  home.shellAliases = {
    update = "sudo nixos-rebuild switch --flake /home/${username}/.dotnix#${hostname}";
  };

  imports = [
    ../../modules/home/dconf/dconf.nix
    ../../modules/home/firefox/firefox.nix

    # NVF
    inputs.nvf.homeManagerModules.default
    ../../modules/home/nvf/nvf.nix
  ];

  fonts.fontconfig = {
    enable = true;
    # antialiasing = true;
    # hinting = "slight"; # null or one of "none", "slight", "medium", "full"
    # subpixelRendering = "rgb"; # one of "rgb", "bgr", "vrgb", "vbgr", "none"
  };

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

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };

  programs.mpv.enable = true;
  xdg.configFile."mpv" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotnix/config/mpv";
    recursive = true;
  };

  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  #   viAlias = true;
  #   vimAlias = true;
  #   withNodeJs = true;
  #   withPython3 = true;
  #   withRuby = true;
  # };

  # xdg.configFile."nvim" = {
  #   source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotnix/config/nvim";
  #   recursive = true;
  # };
}
