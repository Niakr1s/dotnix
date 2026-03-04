{
  inputs,
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  hostname,
  username,
  stateVersion,
  ...
}: let
  unstablePkgs = import nixpkgs-unstable {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };
in {
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_6_18; # Nvidia compatibility

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  # Garbage collection daily
  nix.gc = {
    automatic = true;
    dates = "21:00";
  };

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "${hostname}"; # Define your hostname.
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Moscow";

  # These variables will be set by PAM early in the login process.
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };

  # These variables will be set on shell initialisation (e.g. in /etc/profile).
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  services.v2raya = {
    enable = true;
    package = pkgs.unstable.v2raya;
    cliPackage = pkgs.unstable.xray;
  };

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = ["gemma3:12b"];
  };

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    torrentingPort = 6881;
    webuiPort = 8080;
    serverConfig = {
      BitTorrent = {
        Session = {
          DefaultSavePath = "/srv/torrents"; # systemd will create this directory for us
          TempPath = "/srv/torrents/temp";
          TorrentExportDirectory = "/srv/torrents/.torrents";
          AlternativeGlobalDLSpeedLimit = 6000;
          DisableAutoTMMByDefault = false;
          GlobalMaxRatio = 1; # stop seeding after ratio 1
          ShareLimitAction = "Stop";
          QueueingSystemEnabled = false;
          SubcategoriesEnabled = true;
        };
      };
      Core = {
        AutoDeleteAddedTorrentFile = "IfAdded";
      };
      Preferences = {
        WebUI = {
          Username = "nea";
          Password_PBKDF2 = "@ByteArray(agI2Tr50yXx8i5Gm9kTfkA==:79jfEujByGcX3FQTbLt2IIm4t7pSxfQhwVIcVFOlTKLtJ1XIJPnDN28+w2udq2ksKpr3UUjxKoCYO6WzaiT+8w==)";
        };
      };
    };
  };

  # man tmpfiles.d
  systemd.tmpfiles.rules = [
    "R /var/lib/qBittorrent/qBittorrent/config/categories.json - - - - -"
    "C /var/lib/qBittorrent/qBittorrent/config/categories.json 0644 qbittorrent qbittorrent - /home/nea/.dotnix/config/qBittorrent/config/categories.json"
    "R /var/lib/qBittorrent/qBittorrent/config/watched_folders.json - - - - -"
    "C /var/lib/qBittorrent/qBittorrent/config/watched_folders.json 0644 qbittorrent qbittorrent - /home/nea/.dotnix/config/qBittorrent/config/watched_folders.json"
    "d /srv/torrents 2770 qbittorrent qbittorrent - -"
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.gnome.core-apps.enable = true;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome-clocks
    #gnome-control-center
    gnome-initial-setup
    gnome-music
    #pkgs.gnome-connections
    pkgs.gnome-contacts
    pkgs.gnome-tour
    #pkgs.snapshot
    cheese
    epiphany
    evince
    geary
    totem
    yelp
    decibels
    snapshot
    showtime
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  # Hyprland
  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # https://github.com/lutris/docs/blob/master/HowToEsync.md
  # The Lutris documentation shows how to make your system esync compatible. These steps can be achieved on NixOS with the config below
  # systemd.extraConfig = "DefaultLimitNOFILE=524288"; deprecated, using systemd.settings.Manager
  systemd.settings.Manager = {
    DefaultLimitNOFILE = 524288;
  };
  security.pam.loginLimits = [
    {
      domain = "nea"; # your user name
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];

  programs.gamemode.enable = true; # for performance mode

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # You probably want stable or beta.
    package = config.boot.kernelPackages.nvidiaPackages.stable; # Same as production
    # package = config.boot.kernelPackages.nvidiaPackages.production; # Latest production driver
    # package = config.boot.kernelPackages.nvidiaPackages.beta;   # Latest beta driver
    # package = config.boot.kernelPackages.nvidiaPackages.latest; # Same as production
    # package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_535; # Older versions
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_340;
    # package = config.boot.kernelPackages.nvidiaPackages.dc; # Datacenter drivers
    # package = config.boot.kernelPackages.nvidiaPackages.dc_565;
    # package = config.boot.kernelPackages.nvidiaPackages.dc_535;

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # If you have an GPU with Turing architecture (RTX 20-Series) or newer set hardware.nvidia.open to true.
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
  };

  # enable the x11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us,ru";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nea = {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "audio" "disk" "networkmanager" "qbittorrent"];
    uid = 1000;
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  environment.shellAliases = {
    ll = "ls -l";
    la = "ls -la";
    update = "sudo nixos-rebuild switch --flake /home/nea/.dotnix#desktop";
  };

  environment.shells = with pkgs; [zsh];

  system.userActivationScripts.zshrc = "touch .zshrc";
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    syntaxHighlighting = {
      enable = true;
    };

    autosuggestions = {
      enable = true;
      async = true;
    };

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "robbyrussell";
    };
  };

  programs.firefox = {
    enable = true;

    languagePacks = ["en-US"];

    preferences = {
      "privacy.resistFingerprinting" = true;
    };

    policies = {
      DisableTelemetry = true;
    };
  };

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    btop-cuda
    tree
    bat
    yazi
    fzf
    ripgrep

    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
    gnomeExtensions.forge
    dconf-editor

    protonup-ng # GUI for installing custom Proton versions like GE_Proton
    mangohud
    lutris
    retroarch

    # ------

    # On x86_64-linux, the wine package supports by default both 32- and 64-bit applications.
    # On every other platform, the wine package supports by default only 32-bit applications.

    # wineWow64Packages.stable # support both 32- and 64-bit applications
    # wine # support 32-bit only (read above!)
    # (wine.override { wineBuild = "wine64"; }) # support 64-bit only
    # wine64 # support 64-bit only
    # wineWow64Packages.staging # wine-staging (version with experimental features)
    # winetricks # winetricks (all versions)
    wineWow64Packages.waylandFull # native wayland support (unstable)

    # ------
  ];

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = "${stateVersion}"; # Set this to first installed version, and then don't change it
}
