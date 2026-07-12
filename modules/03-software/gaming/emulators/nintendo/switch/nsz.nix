{ prodKeysFilePath }:
{
  pkgs,
  flakeLib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    nsz
  ];

  imports = [
    (flakeLib.mkHomeLink {
      homePath = ".switch/prod.keys";
      flakePath = prodKeysFilePath;
    })
  ];
}
