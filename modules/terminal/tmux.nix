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
    ];

    extraConfig = ''
      setw -g mode-keys vi
      set -g mouse on
      unbind C-b
      set -g prefix C-q

      # Pane navigation with prefix + hjkl
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Direct pane movement with Alt+hjkl (no prefix needed)
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # Use Alt+hjkl for immediate resizing
      bind -r M-h resize-pane -L 10
      bind -r M-j resize-pane -D 10
      bind -r M-k resize-pane -U 10
      bind -r M-l resize-pane -R 10

      # Unbind pane resizing
      unbind C-h
      unbind C-j
      unbind C-k
      unbind C-l

      # restore on tmux server start
      set -g @continuum-restore 'on'

      set -g status-right "%H:%M:%S %d/%m/%Y"
      set -g status-interval 1

      set -g set-titles on
      set -g set-titles-string "#{pane_current_command}"
    '';
  };
}
