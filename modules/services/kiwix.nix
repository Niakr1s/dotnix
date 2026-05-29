{
  lib,
  inputs,
  config,
  flakeLib,
  ...
}:
let
  libraryPath = "/data/hdd1/kiwix/library.xml";
in
{
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/misc/kiwix-serve.nix"
    (flakeLib.localhostReverseProxy "kiwix" config.services.kiwix-serve.port)
  ];

  services.kiwix-serve = {
    enable = true;
    port = 7777;
    libraryPath = "${libraryPath}";
  };
}
