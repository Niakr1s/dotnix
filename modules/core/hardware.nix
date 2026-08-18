{
  lib,
  ...
}:
{
  fileSystems = {
    "/" = {
      options = lib.mkForce [
        "compress=zstd"
      ];
    };
    "/home" = {
      options = lib.mkForce [
        "subvol=home"
        "compress=zstd"
      ];
    };

    "/nix" = {
      options = lib.mkForce [
        "subvol=nix"
        "compress=zstd"
      ];
    };
  };
}
