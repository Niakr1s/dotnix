{
  hostname,
  username,
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
    nps = "nps -e=true";

    # gvfs
    gvcd = "/run/user/1000/gvfs";

    nix-shell = "nix-shell --run zsh";

    atop = "atop -Kk";
  };

  home-manager.users.${username} = {
    home.shellAliases = {
      nixcd = "cd ${flakeDir}";
      nixedit = "cd ${flakeDir} && vim .";
      nixupdate = "systemd-inhibit sudo nixos-rebuild switch --flake ${flakeDir}#${hostname}";
    };
  };
}
