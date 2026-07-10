{
  pkgs,
  username,
  selectedWine,
  ...
}:
{
  # https://github.com/lutris/docs/blob/master/HowToEsync.md
  # The Lutris documentation shows how to make your system esync compatible. These steps can be achieved on NixOS with the config below
  # systemd.extraConfig = "DefaultLimitNOFILE=524288"; deprecated, using systemd.settings.Manager
  systemd.settings.Manager = {
    DefaultLimitNOFILE = 524288;
  };
  security.pam.loginLimits = [
    {
      domain = "${username}"; # your user name
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  users.users.${username} = {
    extraGroups = [ "gamemode" ];
  };

  environment.systemPackages = with pkgs; [
    selectedWine
    winetricks
    umu-launcher # umu-run
    protonplus # manage proton versions
    steam-run
  ];

  environment.variables = {
    WINE_BIN = "${selectedWine}/bin/.wine"; # hack for winetricks
  };

  environment.shellAliases = {
    winetricks = "WINE_BIN=$(dirname $(readlink $(which wine)))/.wine winetricks";
  };
}
