{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.packages.gaming;

  link_steam_runtime_to_umu =  pkgs.writeScriptBin "link_steamruntime_to_umu" ''
    rm -rf ~/.local/share/umu/steamrt*
    ln -s ~/.local/share/Steam/steamapps/common/SteamLinuxRuntime ~/.local/share/umu/steamrt1
    ln -s ~/.local/share/Steam/steamapps/common/SteamLinuxRuntime ~/.local/share/umu/steamrt # dunno if it with prefix 1
    ln -s ~/.local/share/Steam/steamapps/common/SteamLinuxRuntime_soldier ~/.local/share/umu/steamrt2
    ln -s ~/.local/share/Steam/steamapps/common/SteamLinuxRuntime_sniper ~/.local/share/umu/steamrt3
    ln -s ~/.local/share/Steam/steamapps/common/SteamLinuxRuntime_4 ~/.local/share/umu/steamrt4
  '';
in
{
  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "ntsync" ];

    environment.systemPackages = with pkgs; [
      link_steam_runtime_to_umu

      cfg.wine
      winetricks

      mangohud
      lutris
    ];

    warnings = [
      "You can download all steam runtimes from steam tools and link them via 'link_steamruntime_to_umu' script"
    ];

    programs = {
      gamemode.enable = true;
      gamescope.enable = true;

      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        protontricks.enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
    };

    environment.variables = {
      WINE_BIN = "${cfg.wine}/bin/.wine"; # hack for winetricks
    };
  };
}
