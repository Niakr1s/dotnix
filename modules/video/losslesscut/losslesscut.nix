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
}: {
  environment.systemPackages = with pkgs; [
    losslesscut-bin
  ];

  # It works, but maybe it will be better to manually copy a needed file
  # home-manager.users.${username} = {lib, ...}: {
  #   home.activation.installLosslessCutConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #     mkdir -p /home/${username}/.config/LosslessCut
  #     cp -f ${flakeDir}/config/LosslessCut/* /home/${username}/.config/LosslessCut/
  #   '';
  # };
}
