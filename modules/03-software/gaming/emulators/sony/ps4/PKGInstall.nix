{ pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
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
}
