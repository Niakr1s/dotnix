{
  config,
  lib,
  ...
}: let
  cfg = config.modules.core.zram;
in {
  config = lib.mkIf (cfg.enable) {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = cfg.percent;
      priority = 100;
    };

    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
  };
}
