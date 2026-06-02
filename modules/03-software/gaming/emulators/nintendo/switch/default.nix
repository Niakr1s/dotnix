{
  flakeDir,
  ...
}:
let
  version = "21.2.0";
  prodKeysFilePath = "${flakeDir}/secrets/emulators/switch/prod.v${version}.keys";
in
{
  imports = [
    (import ./nsz.nix { inherit prodKeysFilePath; })
    ./eden.nix
    ./ryubing.nix
  ];
}
