{
  pkgs,
  ...
}:
let
  shadps4-no-desktop = pkgs.symlinkJoin {
    name = "shadps4-no-desktop";
    paths = [ pkgs.unstable.shadps4 ];
    buildInputs = [ pkgs.coreutils ];
    postBuild = ''
      rm -f $out/share/applications/net.shadps4.shadPS4.desktop
    '';
  };

  # Launcher
  PKGInstall = pkgs.stdenv.mkDerivation rec {
    pname = "PKGInstall";
    version = "2025-10-24-96c7890";

    src = pkgs.fetchzip {
      url = "https://github.com/Muggle345/PKGInstall/releases/download/Release/PKGInstall-ubuntu64-${version}.zip";
      hash = "sha256-9ZTWFggwz6Rr3Raa5aABcvOMOt7flUKBbJWK/AIToCQ=";
    };

    buildInputs = with pkgs.qt6; [
      qtbase
      qtdeclarative
      qtmultimedia
      qttools
    ];

    nativeBuildInputs = with pkgs.qt6; [
      wrapQtAppsHook
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp PKGInstall $out/bin/
      chmod +x $out/bin/*
    '';
  };

  # Launcher
  shadps4-qtlauncher = pkgs.callPackage (
    { appimageTools, fetchzip }:
    let
      pname = "shadps4-qtlauncher";
      version = "224";

      extracted = fetchzip {
        url = "https://github.com/shadps4-emu/shadps4-qtlauncher/releases/download/v224/shadPS4QtLauncher-linux-qt-v${version}.zip";
        hash = "sha256-/h/ZPZ2c1WehizJWY719r8OXhZk0UO9/hr6fxtiK7mo=";
      };

      src = "${extracted}/shadPS4QtLauncher-qt.AppImage";
    in
    appimageTools.wrapType2 { inherit pname version src; }
  ) { };

  shadps4-qtlauncher-desktop = pkgs.makeDesktopItem {
    name = "shadps4-qtlauncher";
    exec = "${shadps4-qtlauncher}/bin/shadps4-qtlauncher";
    icon = "${shadps4-no-desktop}/share/icons/hicolor/512x512/apps/net.shadps4.shadPS4.png"; # Adjust path if icon exists
    desktopName = "shadPS4 Qt Launcher";
    comment = "Qt Launcher for shadPS4 Emulator";
    categories = [
      "Game"
      "Emulator"
    ];
    terminal = false;
    startupNotify = true;
  };

  # pkg extract tool
  ps4-pkg-tool = pkgs.stdenv.mkDerivation rec {
    pname = "ps4-pkg-tool";
    version = "20250825-123142-e7c40358";

    src = pkgs.fetchzip {
      url = "https://github.com/xXJSONDeruloXx/ps4-pkg-tools/releases/download/v${version}/ps4-pkg-tools-Linux.tar.gz";
      hash = "sha256-DV+3a2QdBJhEhV6YKd4oPIynjrZ1Evu88Wu+e2W4A+s=";
      stripRoot = false;
    };

    # Add Qt library and wrapping hook
    buildInputs = [
      pkgs.qt6.qtbase
    ];

    nativeBuildInputs = [
      pkgs.autoPatchelfHook # Fixes library paths for prebuilt binaries
      pkgs.qt6.wrapQtAppsHook # Wraps Qt apps with correct environment
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp -r * $out/bin/
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    # shadps4-no-desktop # turned off because it doesn't work and it's better to use qtlauncher to download latest version
    shadps4-qtlauncher
    shadps4-qtlauncher-desktop
    ps4-pkg-tool
    PKGInstall
  ];
}
