{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  stateVersion,
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

    # NVF
    # inputs.nvf.homeManagerModules.default # TODO
    ../../modules/editors/nvf/nvf.nix
  ];

  # System packages
  environment.systemPackages = with pkgs; [
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

    dconf-editor # you probably need it even in not gnome environment
  ];

  # Home packages
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      telegram-desktop
    ];
  };
}
