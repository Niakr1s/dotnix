{
  inputs,
  config,
  lib,
  pkgs,
  hostname,
  unstablePkgs,
  username,
  stateVersion,
  ...
}: {
  home.packages = [pkgs.tealdeer];
  services.tldr-update = {
    enable = true;
    package = pkgs.tealdeer;
    period = "weekly";
  };
}
