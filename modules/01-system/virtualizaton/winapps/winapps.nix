{
  system,
  username,
  flakeDir,
  winapps,
  ...
}:
{
  environment.systemPackages = [
    winapps.packages."${system}".winapps
    winapps.packages."${system}".winapps-launcher
  ];

  users.users.${username}.extraGroups = [ "kvm" ];

  home-manager.users.${username} =
    { config, ... }:
    {
      home.file.".config/winapps" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/winapps";
        recursive = true;
      };
    };
}
