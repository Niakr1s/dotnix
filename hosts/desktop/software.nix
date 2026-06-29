{
  # Modules
  imports = [
    ### 01-system
    ../../modules/01-system/virtualizaton/docker/services/comfyui.nix
    ../../modules/01-system/virtualizaton/docker/services/flibusta.nix
    ../../modules/01-system/virtualizaton/winapps/winapps.nix

    ### 03-software
    ../../modules/03-software/ai/aichat.nix
    ../../modules/03-software/ai/ollama.nix
    ../../modules/03-software/documents/documentation/kiwix.nix

    ../../modules/03-software/gaming/default.nix
    ../../modules/03-software/gaming/emulators/multi-system/retroarch.nix
    ../../modules/03-software/gaming/emulators/nintendo/azahar.nix
    ../../modules/03-software/gaming/emulators/nintendo/switch
    ../../modules/03-software/gaming/emulators/sony/ps2/pcsx2.nix
    ../../modules/03-software/gaming/emulators/sony/ps3/rpcs3.nix
    ../../modules/03-software/gaming/emulators/sony/ps4
    ../../modules/03-software/gaming/launchers/lutris.nix
    # ../../modules/03-software/gaming/launchers/steam.nix # it doesn't works correctly
    ../../modules/03-software/gaming/tools/mangohud.nix
  ];
}
