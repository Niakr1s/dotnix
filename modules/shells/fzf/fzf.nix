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
in {
  home-manager.users.${username} = {
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
  };
}
