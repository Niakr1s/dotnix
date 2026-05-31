{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ./shadps4.nix { })
    (pkgs.callPackage ./PKGInstall.nix { })
    # (pkgs.callPackage ./ps4-pkg-tool.nix { })
  ];
}
