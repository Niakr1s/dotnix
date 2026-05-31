{
  pkgs,
  username,
  flakeDir,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # retroarch-full
    # retroarch
    (retroarch.withCores (cores:
      with cores; [
        fbneo # Arcade - Fbneo
        mame2003-plus # Arcade - Mame 2003 Plus
        stella # Atari - 2600
        beetle-pce-fast # NEC - TurboGrafx-16 / TurboGrafx CD
        citra # Nintendo - 3DS
        melonds # Nintendo - DS
        gambatte # Nintendo - GB / GB Color
        mgba # Nintendo - GBA
        dolphin # Nintendo - GameCube / Wii
        mupen64plus # Nintendo -N64
        nestopia # Nintendo - NES
        bsnes # Nintendo - SNES
        scummvm # ScummVM
        flycast # Sega - Dreamcast
        genesis-plus-gx # Sega - Game Gear / Genesis / Master System / Sega CD
        beetle-saturn # Sega - Saturn
        neocd # SNK - NEO GEO
        beetle-psx # Sony - PS1
        pcsx2 # Sony - PS2
      ]))
  ];

  # home-manager.users.${username} = {config, ...}: {
  #   home.file.".config/retroarch/retroarch.cfg" = {
  #     source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/retroarch/retroarch.cfg";
  #   };
  # };
}
