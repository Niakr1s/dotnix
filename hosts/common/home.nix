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
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "maran";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    tmux.enableShellIntegration = true;

    defaultCommand = "fd --type f --hidden --exclude .git --exclude dosdevices --exclude drive_c";

    # Command line options for the CTRL-T keybinding.
    # fileWidgetCommand = "";
    fileWidgetOptions = [
      "--walker-skip '.git,node_modules,target,dosdevices,drive_c'"
      "--preview 'bat -n --color=always {}'"
    ];

    # Command line options for the ALT-C keybinding.
    # changeDirWidgetCommand = "";
    changeDirWidgetOptions = [
      "--walker-skip '.git,node_modules,target,dosdevices,drive_c'"
      "--preview 'tree -C {}'"
    ];

    # Command line options for the CTRL-R keybinding.
    historyWidgetOptions = [
    ];
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
}
