{
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkOption
    types
    ;
  inherit (types) bool;

  cfg = config.features.ai;
  headless = config.core.headless;
in
{
  options.features.ai = {
    enable = mkOption {
      type = bool;
      default = !headless;
      description = "AI Tools";
    };
    llama = {
      enable = mkOption {
        type = bool;
        default = cfg.enable;
        description = "Enable llama service";
      };
    };
  };

  imports = [
    ./llama.nix
  ];
}
