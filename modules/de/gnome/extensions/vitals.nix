{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  hostname,
  username,
  home-manager,
  ...
}: let
in {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      gnomeExtensions.vitals
    ];
    dconf = {
      settings = with lib.hm.gvariant; {
        "org/gnome/shell" = {
          enabled-extensions = [
            pkgs.gnomeExtensions.vitals.extensionUuid
          ];
        };
        "org/gnome/shell/extensions/vitals" = {
          update-time = 5;

          hide-icons = false;
          icon-style = 1;

          hot-sensors = [
            # cpu
            "_processor_usage_"
            "_memory_usage_"
            "__temperature_avg__"

            # gpu
            "_gpu#1_utilization_"
            "_gpu#1_memory_utilization_"
            "_temperature_gpu_"

            # network
            "__network-rx_max__"
          ];

          show-battery = true;
          show-fan = true;
          show-gpu = true;
          show-memory = true;
          show-network = true;
          show-processor = true;
          show-storage = true;
          show-system = true;
          show-temperature = true;
          show-voltage = true;
        };
      };
    };
  };
}
