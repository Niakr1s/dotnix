{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.packages.gaming.emulators.retroarch;
in
{
  config = lib.mkIf cfg.enable {

    warnings = [
      "Retroarch bioses download script:\ncurl -fsSL https://raw.githubusercontent.com/Abdess/retrobios/main/install.sh | sh"
    ];

    environment.systemPackages = with pkgs; [
      retroarch-full
      retroarch-assets
    ];
  };
}
