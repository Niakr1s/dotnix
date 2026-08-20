{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.packages.gaming.emulators.sony-ps2;

  bios = rec {
    a = {
      name = "ps2-0230a-20080220.bin";
      firmware = pkgs.fetchurl {
        name = "ps2-firmware-a";
        url = "https://download.ps2chd.com/chdps2emu/bios/${a.name}";
        hash = "sha256-9gntHKYkN1GYKM3YJLXqeUF/11bnGkF4RDSD43gf7dI=";
      };
    };
    e = {
      name = "ps2-0230e-20080220.bin";
      firmware = pkgs.fetchurl {
        name = "ps2-firmware-e";
        url = "https://download.ps2chd.com/chdps2emu/bios/${e.name}";
        hash = "sha256-y1qR/aDo4rKgEsC019tYMSgcMqic1lnG6PZN8f4gTmk=";
      };
    };
  };
  biosPath = ".config/PCSX2/bios";
in {
  config = lib.mkIf cfg.enable {
    warnings = [
      "Playstation2 bioses are available under ~/${biosPath}"
    ];

    environment.systemPackages = with pkgs; [
      pcsx2
    ];

    home = {
      "${biosPath}/${bios.a.name}".source = bios.a.firmware;
      "${biosPath}/${bios.e.name}".source = bios.e.firmware;
    };
  };
}
