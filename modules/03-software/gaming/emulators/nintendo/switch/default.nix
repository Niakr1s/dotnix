{
  flakeDir,
  ...
}:
let
  # TODO: Probably I should use secrets flake path or something
  prodKeysFilePath = "${flakeDir}/secrets/emulators/nintendo/switch/prod.v${firmwareVersion}.keys";
  firmwareVersion = "21.2.0";
  firmwareUrl = "https://github.com/THZoria/NX_Firmware/releases/download/${firmwareVersion}/Firmware.${firmwareVersion}.zip";
in
{
  warnings = [
    "Switch firmware: ${firmwareUrl}"
  ];

  imports = [
    (import ./nsz.nix { inherit prodKeysFilePath; })
    (import ./eden.nix { inherit prodKeysFilePath; })
    (import ./ryubing.nix { inherit prodKeysFilePath; })
  ];
}
