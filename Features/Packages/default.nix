{
  lib,
  ...
}:
let
  inherit (lib)
    filterAttrs
    hasSuffix
    ;
  importFiles = builtins.attrNames (
    filterAttrs (n: t: t == "regular" && hasSuffix ".nix" n && n != "default.nix") (
      builtins.readDir ./.
    )
  );

in
{
  imports = map (n: ./${n}) importFiles;
}
