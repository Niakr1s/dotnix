{
  config,
  lib,
  pkgs,
  hjem,
  ...
}:
let
  cfg = config.modules.packages.gaming.emulators.sony-ps3;
  user = config.modules.core.user;

  firmware = pkgs.fetchurl {
    name = "ps3-firmware";
    url = "http://dus01.ps3.update.playstation.net/update/ps3/image/us/2026_0318_a2b60b6ac1d2e49e230144345616927c/PS3UPDAT.PUP";
    hash = "sha256-FYRx/YNPjqgDYTa2qrQ82Gx7pz15yjDgrzwP4AAc82U=";
  };
  firmwarePath = ".config/rpcs3/PS3UPDAT.PUP";
in
{
  config = lib.mkIf cfg.enable {
    warnings = [
      "Playstation3 firmware is available under ${firmwarePath}"
    ];

    environment.systemPackages = with pkgs; [
      rpcs3
    ];

    hjem.users.${user}.files = {
      "${firmwarePath}".source = firmware;
    };
  };
}
