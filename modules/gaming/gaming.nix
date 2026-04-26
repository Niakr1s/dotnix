{
  inputs,
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  hostname,
  username,
  ...
}: let
in {
  imports = [
    ./ryubing/ryubing.nix
    ./rpcs3/rpcs3.nix
  ];

  # https://github.com/lutris/docs/blob/master/HowToEsync.md
  # The Lutris documentation shows how to make your system esync compatible. These steps can be achieved on NixOS with the config below
  # systemd.extraConfig = "DefaultLimitNOFILE=524288"; deprecated, using systemd.settings.Manager
  systemd.settings.Manager = {
    DefaultLimitNOFILE = 524288;
  };
  security.pam.loginLimits = [
    {
      domain = "${username}"; # your user name
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];
}
