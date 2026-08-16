{
  pkgs,
  ...
}:
{
  # Конфигурация системных шрифтов
  fonts.packages = with pkgs; [
    # Способ А: Только символы (подмешивает иконки к любому вашему текущему шрифту)
    nerd-fonts.symbols-only

    # Способ Б: Полноценные шрифты со встроенными иконками (выберите нужные)
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  fonts.fontconfig = {
    enable = true;
    antialias = true; # Ensures antialiasing is turned on globally

    # Subpixel rendering configurations
    subpixel = {
      rgba = "rgb"; # Most common for standard monitors. Options: "rgb", "bgr", "vrgb", "vbgr", "none"
      lcdfilter = "default"; # Smooths out color fringes. Options: "none", "default", "light", "legacy"
    };

    # Slight or medium hinting usually works best alongside subpixel rendering
    hinting = {
      enable = true;
      autohint = false; # Use the font's internal hinting metrics instead of generic autohinting
      style = "slight"; # "none", "slight", "medium", "full"
    };
  };
}
