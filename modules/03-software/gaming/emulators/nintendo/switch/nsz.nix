{ prodKeysFilePath }:
{
  pkgs,
  username,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    nsz
  ];

  home-manager.users.${username} =
    { config, ... }:
    {
      home.file.".switch/prod.keys" = {
        source = config.lib.file.mkOutOfStoreSymlink prodKeysFilePath;
      };
    };
}
