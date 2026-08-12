{
  config,
  pkgs,
  ...
}:
let
  user = config.core.user;
in
{
  # Конфигурация системных шрифтов
  fonts.packages = with pkgs; [
    # Способ А: Только символы (подмешивает иконки к любому вашему текущему шрифту)
    nerd-fonts.symbols-only

    # Способ Б: Полноценные шрифты со встроенными иконками (выберите нужные)
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # Автоматически подтягивает установленные шрифты в Fontconfig
  fonts.fontconfig.enable = true;
}
