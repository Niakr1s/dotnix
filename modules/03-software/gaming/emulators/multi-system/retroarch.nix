{
  pkgs,
  username,
  ...
}:
let
  bioses = pkgs.fetchzip {
    url = "https://github.com/Abdess/retrobios/releases/download/v2026.04.02/RetroArch_Lakka_v1.22.2_Platform_BIOS_Pack.zip";
    hash = "sha256-Z0oALGjqKw9YP0mG2uaCNJ833GVkuI9IN4/2IpA/7fs=";
    stripRoot = false;
  };
in
{
  warnings = [
    "BIOSes for RetroArch are available at: ${bioses}"
  ];

  environment.systemPackages = with pkgs; [
    retroarch-full
    # retroarch
    # (retroarch.withCores (cores:
    #   with cores; [
    #     fbneo # Arcade - Fbneo
    #     mame2003-plus # Arcade - Mame 2003 Plus
    #     stella # Atari - 2600
    #     beetle-pce-fast # NEC - TurboGrafx-16 / TurboGrafx CD
    #     citra # Nintendo - 3DS
    #     melonds # Nintendo - DS
    #     gambatte # Nintendo - GB / GB Color
    #     mgba # Nintendo - GBA
    #     dolphin # Nintendo - GameCube / Wii
    #     mupen64plus # Nintendo -N64
    #     nestopia # Nintendo - NES
    #     bsnes # Nintendo - SNES
    #     scummvm # ScummVM
    #     flycast # Sega - Dreamcast
    #     genesis-plus-gx # Sega - Game Gear / Genesis / Master System / Sega CD
    #     beetle-saturn # Sega - Saturn
    #     neocd # SNK - NEO GEO
    #     beetle-psx # Sony - PS1
    #     pcsx2 # Sony - PS2
    #   ]))
  ];

  home-manager.users.${username} =
    { config, ... }:
    {
      # this takes too long
      # home.file.".config/retroarch/system" = {
      #   source = "${bioses}/system";
      #   recursive = true;
      # };
    };
}
