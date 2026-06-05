{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 10000;
    baseIndex = 1;
    escapeTime = 0;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      continuum
      yank
      open
      vim-tmux-navigator
    ];

    extraConfig = ''
      setw -g mode-keys vi
      set -g mouse on
      unbind C-b
      set -g prefix C-q

      # Use Alt+hjkl for immediate resizing
      bind -r M-h resize-pane -L 10
      bind -r M-j resize-pane -D 10
      bind -r M-k resize-pane -U 10
      bind -r M-l resize-pane -R 10

      # restore on tmux server start
      set -g @continuum-restore 'on'

      set -g status-right "%H:%M:%S %d/%m/%Y"
      set -g status-interval 1

      set -g set-titles on
      set -g set-titles-string "#{pane_current_command}"
    '';
  };
}
