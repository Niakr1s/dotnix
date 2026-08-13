{
  config,
  lib,
  flakeLib,
  pkgs,
  ...
}:
let
  cfg = config.modules.services.v2raya;
in
{
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        # VPN
        services.v2raya = {
          enable = true;
          cliPackage = pkgs.xray;
        };
      }
      (flakeLib.localhostReverseProxy "v2raya" 2017 { })
    ]
  );
}
