{
  inputs,
  config,
  lib,
  pkgs,
  hostname,
  unstablePkgs,
  username,
  home-manager,
  flakeDir,
  ...
}: {
  # some common aliases
  environment.shellAliases = {
    ll = "ls -l";
    la = "ls -la";
  };

  home-manager.users.${username} = {
    home.shellAliases = {
      update = "sudo nixos-rebuild switch --flake ${flakeDir}#${hostname}";
    };
  };
}
