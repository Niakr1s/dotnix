{
  hostname,
  username,
  flakeDir,
  ...
}:
let
  ezaCmd = "eza --group-directories-first --total-size --icons";
in
{
  # some common aliases
  environment.shellAliases = {
    ll = ezaCmd + " -l"; # "ls -l";
    la = ezaCmd + " -la"; # "ls -la";
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
