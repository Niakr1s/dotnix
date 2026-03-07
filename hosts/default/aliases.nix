{
  inputs,
  config,
  lib,
  pkgs,
  hostname,
  unstablePkgs,
  username,
  stateVersion,
  home-manager,
  ...
}: {
  # some common aliases
  environment.shellAliases = {
    ll = "ls -l";
    la = "ls -la";
  };

  home-manager.users.${username} = {
    home.shellAliases = {
      update = "sudo nixos-rebuild switch --flake /home/${username}/.dotnix#${hostname}";
    };
  };
}
