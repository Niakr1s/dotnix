{
  inputs,
  config,
  lib,
  pkgs,
  hostname,
  unstablePkgs,
  username,
  stateVersion,
  ...
}: {
  # Nixos settings

  system.stateVersion = "${stateVersion}"; # Set this to first installed version, and then don't change it
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Imports

  imports = [
    ../../modules/de/gnome/gnome.nix
    ../../modules/services/qbittorrent/qbittorrent.nix
  ];

  # Kernel

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # Users

  # Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "audio" "disk" "networkmanager"];
    uid = 1000;
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  # Environment

  networking.hostName = "${hostname}"; # Define your hostname.
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_DK.UTF-8";
  services.xserver.xkb.layout = "us,ru";

  # These variables will be set by PAM early in the login process.
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1"; # To enable one-to-one trackpad scrolling in Firefox
  };

  # These variables will be set on shell initialisation (e.g. in /etc/profile).
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  # Services

  # Firewall
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [];
    allowedUDPPorts = [];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pulseaudio.enable = false;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Garbage collection daily
  nix.gc = {
    automatic = true;
    dates = "21:00";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # VPN
  services.v2raya = {
    enable = true;
    package = pkgs.unstable.v2raya;
    cliPackage = pkgs.unstable.xray;
  };

  # DE

  # Some DE stuff
  services.displayManager.gdm.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  # Shells

  environment.shellAliases = {
    ll = "ls -l";
    la = "ls -la";
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
      theme = "maran";
    };
  };

  # Fonts

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

  # Syling

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Software

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
    fd
    ripgrep
    usbutils

    dconf-editor # you probably need it even in not gnome environment

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
}
