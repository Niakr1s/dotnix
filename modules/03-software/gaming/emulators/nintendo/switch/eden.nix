{ prodKeysFilePath }:
{
  pkgs,
  username,
  flakeDir,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    eden
  ];

  home-manager.users.${username} =
    { config, ... }:
    {
      home.file.".local/share/eden/keys/prod.keys" = {
        source = config.lib.file.mkOutOfStoreSymlink prodKeysFilePath;
        force = true;
      };
    };
}
