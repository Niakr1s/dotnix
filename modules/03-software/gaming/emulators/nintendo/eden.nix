{
  pkgs,
  username,
  flakeDir,
  ...
}:
let
  version = "21.2.0";
  prodKeysFile = "prod.v${version}.keys";
  firmwareUrl = "https://github.com/THZoria/NX_Firmware/releases/download/${version}/Firmware.${version}.zip";
in
{
  warnings = [
    "Eden firmware: ${firmwareUrl}"
  ];

  environment.systemPackages = with pkgs; [
    eden
  ];

  home-manager.users.${username} =
    { config, ... }:
    {
      home.file.".local/share/eden/keys/prod.keys" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/Ryujinx/system/${prodKeysFile}";
        force = true;
      };
    };
}
