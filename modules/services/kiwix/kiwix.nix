{inputs, ...}: let
  libraryPath = "/data/hdd1/kiwix/library.xml";
in {
  # imports = ["${unstablePkgs}/nixos/modules/services/web-apps/kiwix-serve.nix"];
  imports = ["${inputs.nixpkgs-unstable}/nixos/modules/services/misc/kiwix-serve.nix"];

  services.kiwix-serve = {
    enable = true;
    port = 7777;
    libraryPath = "${libraryPath}";
  };
}
