{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.modules.features.plasma;
in
{
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
