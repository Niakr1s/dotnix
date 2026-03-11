{
  inputs,
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  disko,
  hostname,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (handbrake.overrideAttrs (previous: {
      nativeBuildInputs = (previous.nativeBuildInputs or []) ++ [pkgs.autoAddDriverRunpath];
    }))
  ];
}
