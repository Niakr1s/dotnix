{
  inputs,
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  disko,
  hostname,
  username,
  flakeDir,
  ...
}: let
  losslesscut_conf = builtins.readFile ./../../../config/LosslessCut/config.json;
  losslesscut_text = lib.replaceStrings ["\n"] ["\\n"] "${losslesscut_conf}";
in {
  environment.systemPackages = with pkgs; [
    losslesscut-bin
  ];
}
