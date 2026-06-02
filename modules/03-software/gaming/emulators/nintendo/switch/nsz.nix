{
  pkgs,
  username,
  flakeDir,
  ...
}:
let
  version = "21.2.0";
  prodKeysFile = "prod.v${version}.keys";
in
{
  environment.systemPackages = with pkgs; [
    nsz
  ];

  home-manager.users.${username} =
    { config, ... }:
    {
      home.file.".switch/prod.keys" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/Ryujinx/system/${prodKeysFile}";
      };
    };
}
