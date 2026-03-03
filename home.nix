{ config, pkgs, ... }:

{
  home.username = "nea";
  home.homeDirectory = "/home/nea";
  home.stateVersion = "25.11";

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
}
