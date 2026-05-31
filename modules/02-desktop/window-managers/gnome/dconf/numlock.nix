### This config should be included if a machine has multiple displays
{
  lib,
  username,
  ...
}: {
  home-manager.users.${username} = {
    dconf = {
      enable = true;
      settings = with lib.hm.gvariant; {
        "org/gnome/desktop/peripherals/keyboard" = {
          # Enable numlock on gdm
          numlock-state = true;
        };
      };
    };
  };
}
