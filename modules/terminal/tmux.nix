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
      # continuum
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

      # Use Alt+hjkl for immediate resizing
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # restore on tmux server start
      set -g @continuum-restore 'on'

      set -g status-right "%H:%M:%S %d/%m/%Y"
      set -g status-interval 1

      set -g set-titles on
      set -g set-titles-string "#{pane_current_command}"
    '';
  };
}
