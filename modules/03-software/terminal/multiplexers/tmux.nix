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
      yank
      open
      vim-tmux-navigator
    ];

    extraConfig = ''
      setw -g mode-keys vi
      set -g mouse on
      unbind C-b
      set -g prefix C-q

      set -g @resurrect-capture-pane-contents 'on'

      # Use Alt+hjkl for immediate resizing
      bind -r M-h resize-pane -L 10
      bind -r M-j resize-pane -D 10
      bind -r M-k resize-pane -U 10
      bind -r M-l resize-pane -R 10

      bind v split-window -h
      bind c split-window -v
      bind t new-window

      set -g status-right "%H:%M:%S %d/%m/%Y"
      set -g status-interval 1

      set -g set-titles on
      set -g set-titles-string "#{pane_current_command}"
    '';
  };
}
