{
  pkgs,
  lib,
  ...
}:
lib.warn "ps4-pkg-tools can't properly extract patches, so use PKGInstall package"
  pkgs.stdenv.mkDerivation
  rec {
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
  }
