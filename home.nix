{ config, pkgs, ... }:

{
  home.username = "nea";
  home.homeDirectory = "/home/nea";
  home.stateVersion = "25.11";

  programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      update = "sudo nixos-rebuild switch --flake /home/nea/.dotnix#desktop";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      update = "sudo nixos-rebuild switch --flake /home/nea/.dotnix#desktop";
    };
    history.size = 10000;
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
}
