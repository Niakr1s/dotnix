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
    telegram-desktop
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

    ### TLDR
    ../../modules/home/tldr/tldr.nix

    ### Video players
    ../../modules/home/mpv/mpv.nix
    ../../modules/home/celluloid/celluloid.nix

    ../../modules/home/git/git.nix

    ../../modules/home/zsh/zsh.nix
    ../../modules/home/fzf/fzf.nix
  ];

  fonts.fontconfig = {
    enable = true;
    # antialiasing = true;
    # hinting = "slight"; # null or one of "none", "slight", "medium", "full"
    # subpixelRendering = "rgb"; # one of "rgb", "bgr", "vrgb", "vbgr", "none"
  };
}
