{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  hostname,
  username,
  home-manager,
  ...
}: let
  unstablePkgs = import nixpkgs-unstable {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };
in {
  # Packages with settings
  imports = [
    ../../modules/de/gnome/gnome.nix
    ../../modules/dconf/dconf.nix

    ../../modules/services/qbittorrent/qbittorrent.nix
    ../../modules/services/v2raya/v2raya.nix

    ../../modules/utilites/tldr/tldr.nix
    ../../modules/browsers/firefox/firefox.nix

    ### Video players
    ../../modules/players/celluloid/celluloid.nix
    ../../modules/players/mpv/mpv.nix

    ### VCS
    ../../modules/vcs/git/git.nix
    ../../modules/vcs/git/gh.nix

    ### Shells
    ../../modules/shells/zsh/zsh.nix
    ../../modules/shells/fzf/fzf.nix

    ### FIle managers
    ../../modules/fm/yazi/yazi.nix

    # NVF
    # inputs.nvf.homeManagerModules.default # TODO
    ../../modules/editors/nvf/nvf.nix
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    ((pkgs.ffmpeg-full.override {
        withUnfree = true; # Allow unfree dependencies (for Nvidia features notably)
        withMetal = false; # Use Metal API on Mac. Unfree and requires manual downloading of files
        withMfx = false; # Hardware acceleration via the deprecated intel-media-sdk/libmfx. Use oneVPL instead (enabled by default) from Intel's oneAPI.
        withTensorflow = false; # Tensorflow dnn backend support (Increases closure size by ~390 MiB)
        withSmallBuild = true; # Prefer binary size to performance.
        withDebug = false; # Build using debug options
      }).overrideAttrs
      (_: {doCheck = false;}))

    ### Crypto
    age
    ssh-to-age
    ssh-to-pgp
    sops
    authenticator
    veracrypt

    vim
    wget
    curl
    git
    btop-cuda
    tree
    bat
    yazi
    fzf
    fd
    ripgrep
    usbutils
    neofetch # for sure
    wine

    ### Archives
    zip
    p7zip
    rar

    dconf-editor # you probably need it even in not gnome environment

    imagemagick
    gnupg
    elinks
    zellij
    yt-dlp
    ytfzf # Posix script to find and watch youtube videos from the terminal
    jq # lightweight and flexible command-line JSON processor
    eza # Modern, maintained replacement for ls
    lazygit # Simple terminal UI for git commands
    miller # Like awk, sed, cut, join, and sort for data formats such as CSV, TSV, JSON, JSON Lines, and positionally-indexed
    visidata # Interactive terminal multitool for tabular data
    delta # Syntax-highlighting pager for git
    parallel # Shell tool for executing jobs in parallel
    duf # Disk Usage/Free Utility
    ncdu # Disk usage analyzer with an ncurses interface
    dua # Tool to conveniently learn about the disk usage of directories
    qalculate-gtk # calculator
    calc # C-style arbitrary precision calculator
    zoxide # Fast cd command that learns your habits
    fortune # Program that displays a pseudorandom message from a database of quotations
    cowsay
    lolcat # Rainbow version of cat
    mutt # Small but very powerful text-based mail client
    rhash # Console utility and library for computing and verifying hash sums of files
    rclone # Command line program to sync files and directories to and from major cloud storage
    rsync # Fast incremental file transfer utility
    trash-cli # trash management
  ];

  # Home packages
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      telegram-desktop
    ];
  };
}
