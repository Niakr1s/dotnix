{
  inputs,
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  hostname,
  username,
  stateVersion,
  ...
}: let
in {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = ["gemma3:12b"];
  };
}
