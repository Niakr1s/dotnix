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
  cia = inputs.cia.packages.${pkgs.system}.default;
in
{
  # System packages
  environment.systemPackages = with pkgs; [
    ### ========== SYSTEM UTILITIES ==========
    ### System Monitoring & Diagnostics
    htop # Interactive process viewer
    bottom # Cross-platform graphical process/system monitor (btm)
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

    ### File Operations & Syncing
    rsync # Fast incremental file transfer
    rclone # Cloud storage sync (Google Drive, S3, etc.)
    curlftpfs # Mount FTP as filesystem
    lftp # Sophisticated FTP/HTTP client
    aria2 # Download utility with multi-connection
    uget # Download manager GUI
    parallel # Execute jobs in parallel
    watchexec # Execute commands when files change

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

    ### Image Processing & Viewing
    gimp # Professional image editor
    inkscape # Vector graphics editor
    conjure # ImageMagick GUI
    imagemagick # Command-line image manipulation
    gthumb # Image viewer/organizer
    chafa # Image-to-text converter for terminal
    ueberzug # Terminal image rendering library

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
    wine # Windows compatibility layer
    winetricks # Wine helper script
    umu-launcher # Universal Proton launcher
    nsz # Nintendo Switch game converter
    cia # Nintendo 3ds games decryptor and converter

    ### ========== NETWORK & INTERNET ==========
    ### Browsers & Viewers
    lynx # Terminal web browser
    elinks # Advanced terminal browser
    kiwix-tools # Offline Wikipedia reader

    ### Network Tools
    curl # HTTP/FTP client
    wget # Download utility
    speedtest-cli # Internet speed test

    ### Messaging
    telegram-desktop # Messaging app

    ### ========== UTILITIES & PRODUCTIVITY ==========
    ### Document Processing
    poppler-utils # PDF utilities (pdftotext)
    pandoc # (not in list - document conversion)

    ### Renaming Tools
    gprename # GUI bulk rename tool
    bulky # GUI bulk rename tool
    vimv # Terminal bulk rename

    ### Archiving (Ordered by format support)
    zip # zip archiver
    unzip # ZIP format
    p7zip # 7-Zip archiver
    _7zz # 7-Zip archiver (both versions)
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

  programs.atop = {
    enable = true;
    atopgpu.enable = true;
    netatop.enable = true;
    setuidWrapper.enable = true;
  };

  # Home packages
  home-manager.users.${username} = {
    # CLI process scheduler and manager.
    services.pueue = {
      enable = true;
    };
  };
}
