{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkIf
    types
    concatStringsSep
    ;
  inherit (types) bool str listOf;

  cfg = config.features.graphicalPkgs;
  user = config.core.user;
  headless = config.core.headless;
in
{
  options.features.graphicalPkgs = {
    enable = mkOption {
      type = bool;
      default = !headless;
      description = "Graphical Packages";
    };
    foot.theme = mkOption {
      type = listOf str;
      default = [ ];
      description = "Import themes for Foot";
      example = "include=path";
    };
  };

  config = mkIf cfg.enable {
    hjem.users.${user} = {
      packages =
        with pkgs;
        [
          ripdrag
          obsidian
          firefox
        ]
        ++ lib.optionals (config.core.isLaptop.enable) [
          moonlight-qt
        ];
    };
  };
}
