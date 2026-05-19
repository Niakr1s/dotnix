{
  pkgs,
  hostname,
  username,
  flakeDir,
  ...
}: {
  imports = [
    ./aliases.nix
    ./fonts.nix
    ./software.nix
    ./programming.nix
    ./games.nix
    ./sops.nix
    ./ssh.nix
    ./iphone.nix
    ./bookmarks.nix
  ];

  ### BLuetooth
  hardware.bluetooth.enable = true;

  # Users

  # Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$COxP910y84jokTHUN9FD0.$Boere7gydjwa9qqwinkeALiRJ0RkYH3dXc3804iMhX6";
    extraGroups = ["wheel" "video" "audio" "disk" "networkmanager" "input"];
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
    NIXOS_OZONE_WL = "1"; # To force wayland
  };

  # These variables will be set on shell initialisation (e.g. in /etc/profile).
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
    # MANPAGER = "vim +Man!";
    BROWSER = "firefox";
  };

  environment.localBinInPath = true;

  # Services

  # Firewall
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [];
    allowedUDPPorts = [];
  };

  # Enable MTP (Media Transfer Protocol)
  services.gvfs.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pulseaudio.enable = false;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 4;
    hourly = 8;
    daily = 0;
    weekly = 0;
    monthly = 0;
  };

  services.smartd = {
    enable = true;
    devices = [
      # {
      # device = "/dev/disk/by-id/ata-WDC-XXXXXX-XXXXXX"; # FIXME: Change this to your actual disk
      # }
    ];
  };

  # Garbage collection weekly
  nix.gc = {
    automatic = true;
    dates = "weekly";
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

  # this not needed anymore, because we'll manage zsh with home-manager
  # system.userActivationScripts.zshrc = "touch .zshrc";

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

  home-manager.users.${username} = {config, ...}: {
    xdg.configFile."mimeapps.list" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/mimeapps.list";
    };
    home.file.".local/bin" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/scripts/${hostname}";
      recursive = true;
    };
    home.pointerCursor = {
      enable = true;
      size = 24; # default: 32
      gtk.enable = true;
      x11.enable = true;

      # package = pkgs.oreo-cursors-plus;
      # name = "oreo_grey_cursors";

      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };
    programs.man.generateCaches = true;
  };

  documentation.man = {
    mandoc.enable = true;
    # Note: man-db must be disabled when using mandoc
    man-db.enable = false;
  };
}
