{
  pkgs,
  username,
  ...
}: {
  # Fonts

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.hack
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    corefonts # Microsoft's TrueType core fonts for the Web
  ];

  fonts.fontconfig = {
    enable = true;
    useEmbeddedBitmaps = true; # Noto Color Emoji doesn't render on Firefox
  };

  home-manager.users.${username} = {
    fonts.fontconfig = {
      enable = true;
      antialiasing = true;
      hinting = "slight"; # null or one of "none", "slight", "medium", "full"
      subpixelRendering = "rgb"; # one of "rgb", "bgr", "vrgb", "vbgr", "none"
    };
  };
}
