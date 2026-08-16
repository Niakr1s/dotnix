{
  config,
  lib,
  flakeLib,
  ...
}:
let
  cfg = config.modules.services.sunshine;
  port = 47989;
  guiPort = port + 1;
in
{
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # 1. Настройки самого Sunshine
      {
        systemd.user.services.sunshine.environment = {
          CUDA_VISIBLE_DEVICES = "1";
        };

        services.sunshine = {
          enable = true;
          autoStart = true;
          openFirewall = true;
          capSysAdmin = true;
          settings = {
            port = port; # default is 47989

            # Разрешаем доступ через ваш реверс-прокси
            # Если вы убрали http:// из Caddy, как в прошлом шаге, используйте https://
            csrf_allowed_origins = "https://sunshine.localhost";

            # Также полезно разрешить доступ со стороны Caddy, если он обращается локально
            web_ui_allowed = "lan";
          };
        };
      }

      # 2. Вызываем функцию реверс-прокси и вмерживаем её результат
      (flakeLib.localhostReverseProxy "sunshine" guiPort { insecureTLS = true; })
    ]
  );

}
