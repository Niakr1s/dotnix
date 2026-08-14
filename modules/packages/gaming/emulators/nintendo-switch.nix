{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.packages.gaming.emulators.nintendo-switch;

  assets = rec {
    version = "22.5.0";
    firmware = pkgs.fetchzip {
      name = "switch-firmware";
      url = "https://github.com/THZoria/NX_Firmware/releases/download/${version}/Firmware.${version}.zip";
      hash = "sha256-1m+zEe/2LY7gg5629wyzlfBp5pq2mmtPvWOvO23lzos=";
      stripRoot = false;
    };
    prod = pkgs.fetchzip {
      name = "switch-prod";
      url = "https://files.prodkeys.net/ProdKeys.NET-v${version}.zip";
      hash = "sha256-fgpBpD732embqYjDg1D6DEWfGXrbTcsXw+26rEK8xrw=";
      stripRoot = false;
    };
  };
  edenConfigPath = ".local/share/eden";
  firmwarePath = "${edenConfigPath}/firmware";
  keysPath = "${edenConfigPath}/keys";
in
{
  config = lib.mkIf cfg.enable {
    warnings = [
      "Nintendo Switch firmware is available under ${firmwarePath}"
    ];

    environment.systemPackages = with pkgs; [
      eden
    ];

    home = {
      "${firmwarePath}".source = "${assets.firmware}";
      "${keysPath}/prod.keys".source = "${assets.prod}/prod.keys";
      "${keysPath}/title.keys".source = "${assets.prod}/title.keys";
    };
  };
}
