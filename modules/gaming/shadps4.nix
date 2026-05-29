{
  pkgs,
  ...
}:
let
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

  icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/shadps4-emu/shadps4-qtlauncher/refs/tags/v224/.github/shadps4.png";
    hash = "sha256-rya0oTnFzS0D48YcB18AevMw//q+8t3sUQwjDC9LR5U=";
  };

  shadps4-qtlauncher-desktop = pkgs.makeDesktopItem {
    name = "shadps4-qtlauncher";
    exec = "${shadps4-qtlauncher}/bin/shadps4-qtlauncher";
    icon = "${icon}"; # Adjust path if icon exists
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
    unstable.shadps4
    shadps4-qtlauncher
    shadps4-qtlauncher-desktop
  ];
}
