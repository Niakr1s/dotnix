{config, ...}: let
  user = config.modules.core.user;
  localeID = "en_DK.UTF-8";
in {
  time.timeZone = "Europe/Moscow";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "${localeID}";
      LC_IDENTIFICATION = "${localeID}";
      LC_MEASUREMENT = "${localeID}";
      LC_MONETARY = "${localeID}";
      LC_NAME = "${localeID}";
      LC_NUMERIC = "${localeID}";
      LC_PAPER = "${localeID}";
      LC_TELEPHONE = "${localeID}";
      LC_TIME = "${localeID}";
    };
  };

  users = {
    groups.${user} = {};
    users.${user} = {
      isNormalUser = true;
      group = user;
      extraGroups = [
        "wheel"
        "video"
        "audio"
      ];
    };
  };
}
