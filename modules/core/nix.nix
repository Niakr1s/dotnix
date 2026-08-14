{
  config,
  pkgs,
  ...
}:
let
  user = config.modules.core.user;
in
{
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.lix;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
    optimise = {
      automatic = true;
      dates = "daily";
    };
    settings = {
      auto-optimise-store = true;
      show-trace = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "${user}"
        "networkmanager"
        "root"
        "@wheel"
      ];
    };
  };
}
