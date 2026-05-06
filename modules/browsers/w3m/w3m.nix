{
  pkgs,
  username,
  flakeDir,
  ...
}: {
  environment.systemPackages = with pkgs; [
    w3m
  ];

  home-manager.users.${username} = {config, ...}: {
    home.file.".w3m/keymap" = {
      enable = false;
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.w3m/keymap";
    };

    home.file.".w3m/config" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.w3m/config";
    };
  };
}
