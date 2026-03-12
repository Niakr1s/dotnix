{
  inputs,
  config,
  lib,
  pkgs,
  hostname,
  unstablePkgs,
  username,
  flakeDir,
  ...
}: {
  imports = [
    ./aliases.nix
    ./fonts.nix
    ./software.nix
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

  # Garbage collection daily
  nix.gc = {
    automatic = true;
    dates = "21:00";
  };

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
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/config/mimeapps.list";
    };
  };
}
