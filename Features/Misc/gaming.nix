{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.features.gaming;
  user = config.core.user;
in
{
  options.features.gaming = {
    enable = lib.mkEnableOption "Enable gaming bundle";

    steam = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Steam (part of the bundle, can be opted out)";
    };
    gamescope = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Gamescope (part of the bundle, can be opted out)";
    };
    gamemode = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Gamemode (part of the bundle, can be opted out)";
    };
    gsr.enable = lib.mkEnableOption "Enable GPU Screen Recorder";
  };

  config = lib.mkIf cfg.enable {

    boot.kernelModules = [ "ntsync" ];

    environment.systemPackages = with pkgs; [
      mangohud
      lutris
    ];

    programs = {

      gamemode.enable = cfg.gamemode;
      gamescope.enable = cfg.gamescope;

      steam = lib.mkIf cfg.steam {
        enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
    };
  };
}
