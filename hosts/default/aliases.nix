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
    mvi = "mv -i";
    cpi = "cp -i";
    rmi = "rm -i";
  };

  home-manager.users.${username} = {
    home.shellAliases = {
      nixcd = "cd ${flakeDir}";
      nixedit = "cd ${flakeDir} && vim .";
      nixupdate = "sudo nixos-rebuild switch --flake ${flakeDir}#${hostname}";
    };
  };
}
