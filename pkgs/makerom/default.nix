{
  stdenv,
  fetchurl,
  unzip,
}:
stdenv.mkDerivation rec {
  pname = "makerom";
  version = "0.19.0";

  src = fetchurl {
    url = "https://github.com/3DSGuy/Project_CTR/releases/download/makerom-v${version}/makerom-v${version}-ubuntu_x86_64.zip";
    hash = "sha256-KHuAnewGTgrVl+PScsSey37tQWk9Xub++dioqiTCSX4=";
  };

  nativeBuildInputs = [unzip];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp makerom $out/bin
    chmod +x $out/bin/makerom
  '';

  meta = with stdenv.lib; {
    description = "Tool for creating CTR (3DS) and NCCH/NCSD files";
    platforms = ["x86_64-linux"];
  };
}
