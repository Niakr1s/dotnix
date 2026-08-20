{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ### System Monitoring & Diagnostics
    bottom # Cross-platform graphical process/system monitor (btm)
    nvtopPackages.full
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
    dust
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
    lftp # Sophisticated FTP/HTTP client
    aria2 # Download utility with multi-connection
    parallel # Execute jobs in parallel
    watchexec # Execute commands when files change
    file # Get file info

    ### Version Control
    git # Distributed version control system
    lazygit # Terminal UI for git commands
    delta # Syntax-highlighting pager for git
    diff-so-fancy # Human-readable diffs
    meld # Visual diff and merge tool (GUI)

    ### Data Processing & Query
    jq # JSON processor
    miller # CSV/JSON/TSV processing (like awk for structured data)
    csvkit # CSV file querying and conversion
    visidata # Terminal multitool for tabular data
    sqlite # Lightweight database engine
    lazysql # Simple database GUI

    ### Text & Search Utilities
    ripgrep # (rg) Fast recursive grep
    ripgrep-all # (rga) Search in PDFs, ZIPs, images, etc.
    fd # Simple, fast find alternative
    fzf # Fuzzy finder
    grex # Generate regex from examples
    csvkit # CSV utilities

    ### Shell Replacements & Improvements
    eza # Modern ls replacement (exa fork)
    mdcat # Markdown rendering in terminal
    vimv # Batch rename files using vim
    bat # (not in list - cat with syntax highlighting)
    tree # Directory listing as tree
    wiki-tui # Wikipedia in terminal
    ddgr # DuckDuckGo from terminal

    ### Fun utilites
    fastfetch # System info
    cmatrix # matrix in terminal
    fortune # Random quotes
    cowsay # ASCII art cows
    lolcat # Rainbow text coloring

    ### Video/Audio Processing
    ffmpeg-full # Complete video/audio conversion (your custom build)
    yt-dlp # YouTube/downloader (supports 1000+ sites)
    gallery-dl # Download image galleries from websites
    ytfzf # Terminal YouTube search and player
    mediainfo # Display media file metadata

    ### Image Processing & Viewing
    imagemagick # Command-line image manipulation
    chafa # Image-to-text converter for terminal
    ueberzug # Terminal image rendering library
    jp2a # convert image to ASCII art

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
    vulkan-tools

    ### Audio
    alsa-tools # ALSA utilities (speaker-test, etc.)
    playerctl # Media player controls (play/pause/next)

    ### Browsers & Viewers
    lynx # Terminal web browser
    elinks # Advanced terminal browser
    kiwix-tools # Offline Wikipedia reader

    ### Network Tools
    curl # HTTP/FTP client
    wget # Download utility
    speedtest-cli # Internet speed test

    ### Nix
    compose2nix # Generate a NixOS config from a Docker Compose project
    nps # Cache and search Nix packages with relevance

    ### Document Processing
    poppler-utils # PDF utilities (pdftotext)
    pandoc # (not in list - document conversion)

    # File search tools
    fsearch

    ### Renaming Tools
    vimv # Terminal bulk rename

    ### Backup & Recovery
    borgbackup # Deduplicating backup tool
    chezmoi

    ### ========== MONITORING & STRESS ==========
    stress-ng # System stress testing
    s-tui # Stress test UI

    ### ========== UNCATEGORIZED / SPECIALIZED ==========
    hyperfine # Benchmark command-line tools
    libnotify # Desktop notifications
    wl-clipboard # Wayland clipboard utilities
    exiftool # application for reading, writing and editing meta information in a wide variety of files.
    perl5Packages.FileMimeInfo # mimeopen
    pciutils # lspci
    calc # calculator

    ### Archiving (Ordered by format support)
    zip # zip archiver
    unzip # ZIP format
    unrar
    p7zip-rar # 7-Zip archiver
    _7zz # 7-Zip archiver (both versions)
    lz4 # fast archiver
    rar # RAR format (proprietary)
    unar # Universal extractor (rar, 7z, zip, etc.)

    ### Documentation
    man-pages-posix
    man-pages
    nixpkgs-manual
    tealdeer

    opencode
    lazydocker
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
