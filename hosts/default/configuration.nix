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
    ../../modules/dconf/dconf.nix

    ../../modules/services/qbittorrent/qbittorrent.nix
    ../../modules/services/v2raya/v2raya.nix

    ../../modules/utilites/tldr/tldr.nix
    ../../modules/browsers/firefox/firefox.nix

    ### Video players
    ../../modules/players/celluloid/celluloid.nix
    ../../modules/players/mpv/mpv.nix

    ### VCS
    ../../modules/vcs/git/git.nix
    ../../modules/vcs/git/gh.nix

    ### Shells
    ../../modules/shells/zsh/zsh.nix
    ../../modules/shells/fzf/fzf.nix

    # NVF
    inputs.nvf.homeManagerModules.default # TODO
    ../../modules/editors/nvf/nvf.nix
  ];

  # Kernel

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  ### BLuetooth
  hardware.bluetooth.enable = true;

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

  # DE

  # Some DE stuff
  services.displayManager.gdm.enable = true;

  services.displayManager.autoLogin = {
    enable = false;
    user = "${username}";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  # Shells

  # A list of permissible login shells for user accounts. No need to mention /bin/sh here, it is placed into this list implicitly.
  # It fixes whether GDM doesn't show user if user's default shell is zsh
  environment.shells = with pkgs; [zsh];
  programs.zsh.enable = true; # in order to home config to work

  # some common aliases
  environment.shellAliases = {
    ll = "ls -l";
    la = "ls -la";
  };

  # this not needed anymore, because we'll manage zsh with home-manager
  # system.userActivationScripts.zshrc = "touch .zshrc";

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

  fonts.fontconfig = {
    enable = true;
    useEmbeddedBitmaps = true; # Noto Color Emoji doesn't render on Firefox
  };

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
    neofetch # for sure

    dconf-editor # you probably need it even in not gnome environment
  ];
}
