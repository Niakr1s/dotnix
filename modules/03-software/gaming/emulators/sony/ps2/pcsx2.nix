{
  pkgs,
  flakeLib,
  ...
}:
let
  linkBios =
    bios:
    flakeLib.mkHomeLink {
      homePath = ".config/PCSX2/bios/${bios}";
      flakePath = "secrets/emulators/sony/ps2/${bios}";
    };
in
{
  warnings = [
    "BIOS for pcsx2: https://emulation.gametechwiki.com/index.php/Emulator_files#PlayStation_2"
  ];

  environment.systemPackages = with pkgs; [
    pcsx2
  ];

  imports = [
    (linkBios "ps2-0230a-20080220.bin")
    (linkBios "ps2-0230e-20080220.bin")
  ];
}
