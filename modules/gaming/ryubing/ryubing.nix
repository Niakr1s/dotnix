{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  hostname,
  username,
  home-manager,
  flakeDir,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ryubing
  ];
}
