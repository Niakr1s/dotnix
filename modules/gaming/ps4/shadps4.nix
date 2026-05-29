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
in
{
  environment.systemPackages = with pkgs; [
    # shadps4-no-desktop # turned off because it doesn't work and it's better to use qtlauncher to download latest version
    shadps4-qtlauncher
    shadps4-qtlauncher-desktop
    (pkgs.callPackage ./ps4-pkg-tool.nix { })
    (pkgs.callPackage ./PKGInstall.nix { })
  ];
}
