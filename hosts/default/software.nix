{
  pkgs,
  inputs,
  username,
  ...
}: {
  # Packages with settings
  imports = [
    ../../modules/de/gnome
    ../../modules/de/niri.nix
    # ../../modules/de/hyprland.nix
    # ../../modules/de/sddm.nix
    ../../modules/de/gdm.nix
    ../../modules/dconf

    ../../modules/services/qbittorrent.nix
    ../../modules/services/v2raya.nix
    ../../modules/services/syncthing.nix

    ../../modules/utilites/tldr.nix
    ../../modules/browsers/firefox.nix
    ../../modules/browsers/w3m.nix
    ../../modules/browsers/tangram.nix

    ### Video players
    # ../../modules/players/celluloid.nix # don't need it, mpv is good
    ../../modules/players/mpv.nix

    ### VCS
    ../../modules/vcs/git.nix
    ../../modules/vcs/git.nix

    ### Shells
    ../../modules/shells/zsh.nix
    ../../modules/shells/bash.nix
    ../../modules/shells/fzf.nix

    ### FIle managers
    ../../modules/fm/yazi.nix

    # NVF
    # inputs.nvf.homeManagerModules.default # TODO
    # ../../modules/editors/nvf.nix
    ../../modules/editors/nvim.nix

    ### Gstreamer
    ../../modules/video/gstreamer.nix

    ### Security
    ../../modules/security/cotp.nix

    ### Docker
    ../../modules/docker

    ### Mail
    # ../../modules/mail.nix # IT downloads whole gmail, don't need it atm

    ### Audio
    ../../modules/audio/tauon.nix

    ### Text
    ../../modules/text/libreoffice.nix

    ### WebDAV
    ../../modules/webdav.nix

    ### Terminal
    # ../../modules/terminal/zellij.nix
    ../../modules/terminal/tmux.nix

    ### IRC
    ../../modules/irc/weechat.nix

    ### nix-ld
    ../../modules/nixld.nix

    ### Notes
    ../../modules/notes/joplin.nix

    ../../modules/dict.nix
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    ((pkgs.ffmpeg-full.override {
        withUnfree = true; # Allow unfree dependencies (for Nvidia features notably)
        withMetal = false; # Use Metal API on Mac. Unfree and requires manual downloading of files
        withMfx = false; # Hardware acceleration via the deprecated intel-media-sdk/libmfx. Use oneVPL instead (enabled by default) from Intel's oneAPI.
        withTensorflow = false; # Tensorflow dnn backend support (Increases closure size by ~390 MiB)
        withSmallBuild = true; # Prefer binary size to performance.
        withDebug = false; # Build using debug options
      }).overrideAttrs
      (_: {doCheck = false;}))

    feh # image viewer
    gthumb # better image viewer

    gptfdisk # gdisk sgidsk cgdisk
    smartmontools # smartctl
    man-pages # man pages for builtins

    ### Crypto
    age
    ssh-to-age
    ssh-to-pgp
    sops
    veracrypt
    cryptsetup # luks

    lisgd # for touchscreen
    libinput # for input hardware

    fastfetch
    cmatrix

    gnumake
    cmake

    vim
    wget
    uv
    deno
    curl
    git
    btop-cuda
    htop
    tree
    bat
    yazi
    fzf
    fd
    ripgrep
    zenity # dialogs for scripts
    fdupes # find diplicate files
    lsof # show opened files
    usbutils
    nsz # switch game converter
    neofetch # for sure
    wine
    winetricks
    libnotify
    mediainfo
    exiftool
    ueberzug
    chafa
    wl-clipboard
    uget # download manager
    aria2 # download program
    gprename # gui bulk rename tool
    bulky # gui bulk rename tool
    vimv # console bulk rename tool
    curlftpfs # ftp
    lftp # ftp
    nps # cache nix package list and search in it by relevance
    meld # visual diff app
    czkawka # find duplicates of files etc
    bleachbit # clean disk
    lm_sensors # system sensors
    poppler-utils # pdftotext and other pdf tools
    ncdu # disk usage with ncurses interface
    mtr # ping + traceroute
    delta # diff between two files
    parallel # speedup stuff
    csvkit # query on csv files
    borgbackup # borg backup solution
    httm # zfs snapshots restore
    kiwix-tools # offline wiki
    lynx # console web browser
    ntfs3g
    ntfsprogs
    nautilus # file manager
    wev # show pressed key
    umu-launcher # universal proton launcher

    inotify-tools # File system events (files/directories being created, modified, deleted)
    audit # provides auditctl (who accessed what file, when)

    ### Image editors
    gimp
    inkscape
    conjure

    ### Archives
    zip
    unzip
    p7zip
    _7zz
    rar
    unar # universal archive extractor (unar, lsar)

    ### DB
    sqlitestudio
    sqlitestudio-plugins
    sqlite
    lazysql

    dconf-editor # you probably need it even in not gnome environment

    imagemagick
    gnupg
    elinks
    yt-dlp
    ytfzf # Posix script to find and watch youtube videos from the terminal
    jq # lightweight and flexible command-line JSON processor
    eza # Modern, maintained replacement for ls
    lazygit # Simple terminal UI for git commands
    miller # Like awk, sed, cut, join, and sort for data formats such as CSV, TSV, JSON, JSON Lines, and positionally-indexed
    visidata # Interactive terminal multitool for tabular data
    delta # Syntax-highlighting pager for git
    parallel # Shell tool for executing jobs in parallel
    duf # Disk Usage/Free Utility
    ncdu # Disk usage analyzer with an ncurses interface
    dua # Tool to conveniently learn about the disk usage of directories
    qalculate-gtk # calculator
    calc # C-style arbitrary precision calculator
    zoxide # Fast cd command that learns your habits
    fortune # Program that displays a pseudorandom message from a database of quotations
    cowsay
    lolcat # Rainbow version of cat
    rhash # Console utility and library for computing and verifying hash sums of files
    rclone # Command line program to sync files and directories to and from major cloud storage
    rsync # Fast incremental file transfer utility
    trash-cli # trash management
    foliate # EPUB, Mobipocket, Kindle, FB2, CBZ, and PDF reader

    # stress testing
    stress-ng
    s-tui
    furmark

    # rom tools
    inputs.cia-unix.packages.${pkgs.system}.default

    gpu-screen-recorder-gtk # GUI app
  ];

  programs.gpu-screen-recorder.enable = true; # For promptless recording on both CLI and GUI

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Home packages
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      telegram-desktop
    ];
  };
}
