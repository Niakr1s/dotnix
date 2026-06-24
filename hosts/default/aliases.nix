{
  hostname,
  username,
  flakeDir,
  ...
}:
let
  ezaCmd = "eza --group-directories-first --icons";
  ezaCmdTotal = ezaCmd + " --total-size";
in
{
  # some common aliases
  environment.shellAliases = {
    l = ezaCmd + " -a";
    ll = ezaCmd + " -l";
    la = ezaCmd + " -la";
    llt = ezaCmdTotal + " -l";
    lat = ezaCmdTotal + " -la";
    mvi = "mv -i";
    cpi = "cp -i";
    rmi = "rm -i";
    nps = "nps -e=true";

    # gvfs
    gvcd = "/run/user/1000/gvfs";

    nix-shell = "nix-shell --run zsh";
    nix-source = "(cd $(nix-instantiate --eval -E '<nixpkgs>') && $SHELL)";

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
