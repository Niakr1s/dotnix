{
  config,
  pkgs,
  ...
}:
let
  user = config.modules.core.user;
  host = config.modules.core.host;
in
{
  environment.localBinInPath = true;
  environment.homeBinInPath = true;

  environment.systemPackages = with pkgs; [
    eza
    fzf
    zoxide
    direnv
    python3Packages.pygments # Добавляет утилиту pygmentize для плагина colorize
  ];

  environment.interactiveShellInit = ''
      # Eza Functions
      ezaCmd() {
        eza --group-directories-first --icons "$@"
      }
      ezaCmdTotal() {
        ezaCmd --total-size "$@"
      }

      # Yazi
      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        command yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d "" cwd < "$tmp"
        [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
        command rm -f -- "$tmp"
      }
    '';

  environment.shellAliases = {
    nixcd="cd /etc/nixos";
    nixupdate="sudo nixos-rebuild --flake /etc/nixos#${host} switch";

    # Git
    gst="git status";
    gd="git diff";
    gds="git diff --staged";
    gp="git push";
    gl="git pull";
    ga="git add";
    gc="git commit";

    # Eza
    l="ezaCmd -a";
    ll="ezaCmd -l";
    la="ezaCmd -la";
    latree="ezaCmd -la --tree";
    llt="ezaCmdTotal -l";
    lat="ezaCmdTotal -la";
    lattree="ezaCmdTotal -la --tree";

    # Chezmoi
    cz="chezmoi -S /etc/nixos/home";
    cza="cz apply";
    cze="cz edit";
    czd="cz diff";
    czs="cz status";
    czm="cz merge-all";

    backup-etc="sudo borg create --progress /data/hdd1/borg/etc::{now} /etc";
    backup-home="borg create --progress /data/hdd1/borg/home::{now} $HOME --exclude '*/.config/rpcs3/dev_hdd0/game/*'";
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      ohMyZsh = {
        enable = true;
        theme = "maran";
        plugins = [
          "colored-man-pages"
          "colorize"
          "direnv"
          "dotenv"
          "extract"
          "fzf"
        ];
      };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  # fix ohmyzsh welcome message
  system.userActivationScripts.zshrc = "touch .zshrc";
}
