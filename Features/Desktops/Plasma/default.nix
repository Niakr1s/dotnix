{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    optionalString
    ;
  inherit (types) str;

  cfg = config.features.plasma;
  user = config.core.user;
in
{
  options.features.plasma = {
    enable = mkEnableOption "Plasma Configuration";
  };

  config = mkIf cfg.enable {
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    programs.kdeconnect.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      elisa
    ];
  };
}
