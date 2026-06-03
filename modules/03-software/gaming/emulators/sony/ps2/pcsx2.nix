{
  pkgs,
  username,
  flakeDir,
  ...
}:
let
  linkBios =
    bios:
    { config, ... }:
    {
      home.file.".config/PCSX2/bios/${bios}" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/secrets/emulators/sony/ps2/${bios}";
        force = true;
      };
    };
in
{
  warnings = [
    "BIOS for pcsx2: https://emulation.gametechwiki.com/index.php/Emulator_files#PlayStation_2"
  ];

  environment.systemPackages = with pkgs; [
    pcsx2
  ];

  home-manager.users.${username} = {
    imports = [
      (linkBios "ps2-0230a-20080220.bin")
      (linkBios "ps2-0230e-20080220.bin")
    ];
  };
}
