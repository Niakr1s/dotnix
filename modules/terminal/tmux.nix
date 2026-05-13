{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 10000;
    baseIndex = 1;

    plugins = with pkgs.tmuxPlugins; [
      resurrect
      continuum
      yank
      open
    ];

    extraConfig = ''
      setw -g mode-keys vi

      # Pane navigation with prefix + hjkl
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # restore on tmux server start
      set -g @continuum-restore 'on'
    '';
  };
}
