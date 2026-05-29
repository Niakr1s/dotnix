{
  pkgs,
  ...
}:
{
  imports = [
    ./shadps4.nix
  ];

  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ./ps4-pkg-tool.nix { })
    (pkgs.callPackage ./PKGInstall.nix { })
  ];
}
