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
      home.file.".local/share/remmina/group_rdp_winapps_127-0-0-1-3389.remmina" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.local/share/remmina/group_rdp_winapps_127-0-0-1-3389.remmina";
      };
    };
}
