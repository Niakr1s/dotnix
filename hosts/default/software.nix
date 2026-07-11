{
  pkgs,
  inputs,
  username,
  ...
}:
let
  ffmpeg-full-custom =
    (pkgs.ffmpeg-full.override {
      withUnfree = true; # Allow unfree dependencies (for Nvidia features notably)
      withMetal = false; # Use Metal API on Mac. Unfree and requires manual downloading of files
      withMfx = false; # Hardware acceleration via the deprecated intel-media-sdk/libmfx. Use oneVPL instead (enabled by default) from Intel's oneAPI.
      withTensorflow = false; # Tensorflow dnn backend support (Increases closure size by ~390 MiB)
      withSmallBuild = true; # Prefer binary size to performance.
      withDebug = false; # Build using debug options
    }).overrideAttrs
      (_: {
        doCheck = false;
      });
  cia-unix = inputs.cia-unix.packages.${pkgs.system}.default;
  selectedWine = pkgs.wineWow64Packages.stagingFull;
in
{
  _module.args.selectedWine = selectedWine;

  environment.systemPackages = with pkgs; [
    ### ========== SYSTEM UTILITIES ==========
    ### System Monitoring & Diagnostics
    htop # Interactive process viewer
    bottom # Cross-platform graphical process/system monitor (btm)
    mission-center # gui process viewer
    procs # Modern ps replacement
    pstree # Display processes as a tree
    lm_sensors # Hardware temperature/voltage monitoring
    smartmontools # S.M.A.R.T. disk health monitoring (smartctl)
    lsof # List open files and processes
    usbutils # USB device utilities (lsusb)
    inotify-tools # Monitor filesystem events
    audit # System call auditing (auditctl)
    nmap # Network discovery and port scanning
    net-tools # Legacy network tools (netstat, ifconfig)
    mtr # Combined ping + traceroute

    ### Disk Management & Analysis
    gptfdisk # GPT partitioning tools (gdisk, sgdisk, cgdisk)
    ntfs3g # NTFS read/write driver
    ntfsprogs # NTFS utilities
    duf # Disk usage/free utility (pretty tables)
    gdu # Disk usage with interactive ncurses interface
    fdupes # Find duplicate files (CLI)
    czkawka # Duplicate finder (GUI + CLI)
    rmlint # Find duplicate/obsolete files with shell script output
    fclones-gui # Duplicate finder GUI
    bleachbit # System cleaner
    trash-cli # Trash management from command line
    scc # shows percentage of programming language usage

    ### File Operations & Syncing
    rsync # Fast incremental file transfer
    rclone # Cloud storage sync (Google Drive, S3, etc.)
    curlftpfs # Mount FTP as filesystem
    lftp # Sophisticated FTP/HTTP client
    aria2 # Download utility with multi-connection
    uget # Download manager GUI
    parallel # Execute jobs in parallel
    watchexec # Execute commands when files change
    file # Get file info

    ### ========== TEXT EDITORS ===============
    vim # vim text editor

    ### ========== DEVELOPMENT TOOLS ==========
    ### Build Systems
    gnumake # Make build system
    cmake # Cross-platform build system

    ### Version Control
    git # Distributed version control system
    lazygit # Terminal UI for git commands
    delta # Syntax-highlighting pager for git
    diff-so-fancy # Human-readable diffs
    meld # Visual diff and merge tool (GUI)

    ### Programming Languages & Runtimes
    uv # Fast Python package installer
    deno # JavaScript/TypeScript runtime
    nodejs # (if needed - not in your list but common)

    ### Data Processing & Query
    jq # JSON processor
    miller # CSV/JSON/TSV processing (like awk for structured data)
    csvkit # CSV file querying and conversion
    visidata # Terminal multitool for tabular data
    sqlite # Lightweight database engine
    sqlitestudio # SQLite GUI
    lazysql # Simple database GUI

    ### Text & Search Utilities
    ripgrep # (rg) Fast recursive grep
    ripgrep-all # (rga) Search in PDFs, ZIPs, images, etc.
    fd # Simple, fast find alternative
    fzf # Fuzzy finder
    grex # Generate regex from examples
    csvkit # CSV utilities

    ### ========== TERMINAL ENHANCEMENTS ==========
    ### Shell Replacements & Improvements
    eza # Modern ls replacement (exa fork)
    zoxide # Smarter cd command
    bottom # System monitor
    procs # Modern ps
    mdcat # Markdown rendering in terminal
    vimv # Batch rename files using vim
    bat # (not in list - cat with syntax highlighting)

    ### Shell Utilities
    ripgrep # Better grep
    fd # Better find
    fzf # Fuzzy finder for shell
    tree # Directory listing as tree
    cheat # Cheatsheets for commands
    wiki-tui # Wikipedia in terminal
    ddgr # DuckDuckGo from terminal

    ### Fun utilites
    fastfetch # System info
    cmatrix # matrix in terminal
    fortune # Random quotes
    cowsay # ASCII art cows
    lolcat # Rainbow text coloring

    ### ========== MULTIMEDIA & GRAPHICS ==========
    ### Video/Audio Processing
    ffmpeg-full-custom # Complete video/audio conversion (your custom build)
    yt-dlp # YouTube/downloader (supports 1000+ sites)
    gallery-dl # Download image galleries from websites
    ytfzf # Terminal YouTube search and player
    mediainfo # Display media file metadata
    audacity # Audio editing
    gpu-screen-recorder-gtk # GPU-accelerated screen recording GUI
    kdePackages.kdenlive # Video editing
    tageditor # Audio tags editor

    ### Image Processing & Viewing
    gimp # Professional image editor
    inkscape # Vector graphics editor
    conjure # ImageMagick GUI
    imagemagick # Command-line image manipulation
    gthumb # Image viewer/organizer
    chafa # Image-to-text converter for terminal
    ueberzug # Terminal image rendering library
    jp2a # convert image to ASCII art
    satty # Modern Screenshot Annotation

    ### E-book Readers
    foliate # EPUB, PDF, Mobi, CBZ reader (GTK)

    ### ========== HARDWARE & PERIPHERALS ==========
    ### Touchscreen/Input
    lisgd # Touchscreen gesture daemon
    libinput # Input device handling
    wev # Show pressed keys/events (Wayland)

    ### System Tools
    cryptsetup # LUKS disk encryption
    veracrypt # Cross-platform disk encryption
    age # Simple modern encryption
    ssh-to-age # Convert SSH keys to age
    ssh-to-pgp # Convert SSH keys to PGP
    sops # Secrets management (encrypted YAML/JSON)
    gnupg # GPG encryption
    rhash # Hash calculation utility

    ### Audio
    alsa-tools # ALSA utilities (speaker-test, etc.)
    playerctl # Media player controls (play/pause/next)

    ### Emulation & Compatibility
    nsz # Nintendo Switch game converter
    cia-unix # Nintendo 3ds games decryptor and converter
    compose2nix # Generate a NixOS config from a Docker Compose project

    ### ========== NETWORK & INTERNET ==========
    ### Browsers & Viewers
    lynx # Terminal web browser
    elinks # Advanced terminal browser
    kiwix-tools # Offline Wikipedia reader
    tor-browser # For onion websites

    ### Network Tools
    curl # HTTP/FTP client
    wget # Download utility
    speedtest-cli # Internet speed test

    ### Messaging
    telegram-desktop # Messaging app

    ### Remote Access & Connectivity
    freerdp # Remote Desktop Protocol client (RDP)
    remmina # Remote Desktop client (supports RDP, VNC, etc)

    ### ========== UTILITIES & PRODUCTIVITY ==========
    ### Security
    keepassxc # Passwords

    ### Document Processing
    poppler-utils # PDF utilities (pdftotext)
    pandoc # (not in list - document conversion)

    # File search tools
    fsearch

    ### Renaming Tools
    gprename # GUI bulk rename tool
    bulky # GUI bulk rename tool
    vimv # Terminal bulk rename

    ### Automation
    crossmacro # Mouse and keyboard macro recorder/player

    ### Archiving (Ordered by format support)
    zip # zip archiver
    unzip # ZIP format
    p7zip # 7-Zip archiver
    _7zz # 7-Zip archiver (both versions)
    lz4 # fast archiver
    rar # RAR format (proprietary)
    unar # Universal extractor (rar, 7z, zip, etc.)

    ### Backup & Recovery
    borgbackup # Deduplicating backup tool
    httm # Interactive ZFS snapshot navigator
    nix-serve # Serve Nix store over HTTP

    ### Office & Calculation
    qalculate-gtk # Powerful calculator (GUI)
    calc # C-style arbitrary precision calculator
    librecad # 2D CAD (AutoCAD alternative)

    ### Documentation
    zeal # Offline API documentation browser

    ### ========== MONITORING & STRESS ==========
    stress-ng # System stress testing
    s-tui # Stress test UI
    furmark # GPU stress test (verify package name)

    ### ========== UNCATEGORIZED / SPECIALIZED ==========
    nps # Cache and search Nix packages with relevance
    hyperfine # Benchmark command-line tools
    zenity # GTK dialog boxes for scripts
    yad # Yet Another Dialog (GTK/Qt)
    dconf-editor # GSettings configuration editor
    libnotify # Desktop notifications
    wl-clipboard # Wayland clipboard utilities
    exiftool # application for reading, writing and editing meta information in a wide variety of files.
  ];

  programs.gpu-screen-recorder.enable = true; # For promptless recording on both CLI and GUI

  programs.command-not-found.enable = false;
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

  # programs.atop = {
  #   enable = true;
  #   atopgpu.enable = true;
  #   netatop.enable = true;
  #   setuidWrapper.enable = true;
  # };

  # Home packages
  home-manager.users.${username} = {
    # CLI process scheduler and manager.
    services.pueue = {
      enable = true;
    };
  };

  # Modules
  imports = [
    ### 01-system
    ../../modules/01-system/mount/iphone.nix
    ../../modules/01-system/mount/webdav.nix
    ../../modules/01-system/security/cotp.nix
    ../../modules/01-system/services/network/avahi.nix
    ../../modules/01-system/services/network/qbittorrent.nix
    ../../modules/01-system/services/network/syncthing.nix
    ../../modules/01-system/services/network/v2raya.nix
    # ../../modules/01-system/services/network/vnc.nix
    ../../modules/01-system/virtualizaton/compatibility/nixld.nix
    ../../modules/01-system/virtualizaton/podman/podman.nix
    ../../modules/01-system/virtualizaton/podman/distrobox.nix
    ../../modules/01-system/virtualizaton/vm/virt-manager.nix

    ### 02-desktop
    ../../modules/02-desktop/display-managers/dms-greeter.nix
    ../../modules/02-desktop/input/dotool.nix
    ../../modules/02-desktop/input/wvkbd.nix
    ../../modules/02-desktop/input/kdeconnect.nix
    ../../modules/02-desktop/window-managers/niri/niri.nix

    ### 03-software
    ../../modules/03-software/development/editors/nvim.nix
    ../../modules/03-software/development/editors/zed.nix
    ../../modules/03-software/development/languages/languages.nix
    ../../modules/03-software/development/version-control/git.nix
    ../../modules/03-software/documents/dictionaries/dict.nix
    ../../modules/03-software/documents/documentation/documentation.nix
    ../../modules/03-software/documents/notes/joplin.nix
    ../../modules/03-software/documents/office/libreoffice.nix
    ../../modules/03-software/documents/text-editors/gnome-text-editor.nix
    ../../modules/03-software/internet/browsers/firefox.nix
    ../../modules/03-software/internet/browsers/w3m.nix
    ../../modules/03-software/internet/irc/weechat.nix
    ../../modules/03-software/multimedia/audio/termusic.nix
    ../../modules/03-software/multimedia/audio/tauon.nix
    ../../modules/03-software/gaming/default.nix
    ../../modules/03-software/gaming/launchers/lutris.nix
    ../../modules/03-software/gaming/games/casual.nix
    ../../modules/03-software/multimedia/video/editors/handbrake.nix
    ../../modules/03-software/multimedia/video/editors/losslesscut.nix
    ../../modules/03-software/multimedia/video/frameworks/gstreamer.nix
    ../../modules/03-software/multimedia/video/players/mpv.nix
    ../../modules/03-software/multimedia/video/streaming/obs.nix
    ../../modules/03-software/file-managers/yazi.nix
    ../../modules/03-software/file-managers/nautilus.nix
    ../../modules/03-software/terminal/emulators/alacritty.nix
    ../../modules/03-software/terminal/multiplexers/tmux.nix
    ../../modules/03-software/terminal/shells/bash.nix
    ../../modules/03-software/terminal/shells/zsh.nix
    ../../modules/03-software/terminal/utilites/bat.nix
    ../../modules/03-software/terminal/utilites/fzf.nix
    ../../modules/03-software/terminal/utilites/tldr.nix
    ../../modules/03-software/terminal/utilites/zoxide.nix
  ];
}
