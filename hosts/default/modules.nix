{
  # Modules
  imports = [

    ### 01-system
    ../../modules/01-system/mount/iphone.nix
    ../../modules/01-system/mount/webdav.nix
    ../../modules/01-system/security/cotp.nix
    ../../modules/01-system/services/network/avahi.nix
    ../../modules/01-system/services/network/qbittorrent.nix
    ../../modules/01-system/services/network/syncthing.nix
    ../../modules/01-system/services/network/v2raya.nix
    ../../modules/01-system/virtualizaton/compatibility/nixld.nix
    ../../modules/01-system/virtualizaton/docker/default.nix
    ../../modules/01-system/virtualizaton/vm/virt-manager.nix

    ### 02-desktop
    ../../modules/02-desktop/config/bookmarks.nix
    ../../modules/02-desktop/display-managers/sddm.nix
    ../../modules/02-desktop/input/dotool.nix
    ../../modules/02-desktop/input/wvkbd.nix
    ../../modules/02-desktop/window-managers/niri.nix

    ### 03-software
    ../../modules/03-software/development/editors/nvim.nix
    ../../modules/03-software/development/editors/zed.nix
    ../../modules/03-software/development/languages/languages.nix
    ../../modules/03-software/development/version-control/git.nix
    ../../modules/03-software/documents/dictionaries/dict.nix
    ../../modules/03-software/documents/documentation/documentation.nix
    # ../../modules/03-software/documents/documentation/kiwix.nix
    ../../modules/03-software/documents/notes/joplin.nix
    ../../modules/03-software/documents/office/libreoffice.nix
    ../../modules/03-software/internet/browsers/firefox.nix
    ../../modules/03-software/internet/browsers/w3m.nix
    ../../modules/03-software/internet/irc/weechat.nix
    ../../modules/03-software/multimedia/audio/tauon.nix
    # ../../modules/03-software/gaming/default.nix
    # ../../modules/03-software/gaming/emulators/multi-system/retroarch.nix
    # ../../modules/03-software/gaming/emulators/nintendo/azahar.nix
    # ../../modules/03-software/gaming/emulators/nintendo/ryubing.nix
    # ../../modules/03-software/gaming/emulators/sony/ps3/rpcs3.nix
    # ../../modules/03-software/gaming/emulators/sony/ps4/default.nix
    # ../../modules/03-software/gaming/emulators/sony/ps4/PKGInstall.nix
    # ../../modules/03-software/gaming/emulators/sony/ps4/ps4-pkg-tool.nix
    # ../../modules/03-software/gaming/emulators/sony/ps4/shadps4.nix
    ../../modules/03-software/gaming/games/casual.nix
    # ../../modules/03-software/gaming/launchers/lutris.nix
    # ../../modules/03-software/gaming/tools/mangohud.nix
    ../../modules/03-software/video/editors/handbrake.nix
    ../../modules/03-software/video/editors/losslesscut.nix
    ../../modules/03-software/video/frameworks/gstreamer.nix
    ../../modules/03-software/video/players/mpv.nix
    ../../modules/03-software/video/streaming/obs.nix
    ../../modules/03-software/terminal/file-managers/yazi.nix
    ../../modules/03-software/terminal/multiplexers/tmux.nix
    ../../modules/03-software/terminal/shells/bash.nix
    ../../modules/03-software/terminal/shells/zsh.nix
    ../../modules/03-software/terminal/utilites/bat.nix
    ../../modules/03-software/terminal/utilites/fzf.nix
    ../../modules/03-software/terminal/utilites/tldr.nix
    ../../modules/03-software/terminal/utilites/zoxide.nix
  ];
}
