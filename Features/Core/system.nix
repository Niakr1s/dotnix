{
  config,
  ...
}:
let
  user = config.core.user;
in
{
  security.sudo-rs.enable = true;

  networking.networkmanager.enable = true;

  users.users.${user} = {
    group = user;
    extraGroups = [ "networkmanager" ];
  };

  documentation = {
    dev.enable = true;
    man.enable = true;
  };
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };
}
