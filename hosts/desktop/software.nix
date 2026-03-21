{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  hostname,
  username,
  home-manager,
  ...
}: let
  unstablePkgs = import nixpkgs-unstable {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };
in {
  # System packages
  environment.systemPackages = with pkgs; [
    kdePackages.kdenlive
  ];

  # Home packages
  home-manager.users.${username} = {
    home.packages = with pkgs; [
    ];
  };
}
