{ prodKeysFilePath }:
{
  pkgs,
  flakeLib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    eden
  ];

  imports = [
    (flakeLib.mkHomeLink {
      homePath = ".local/share/eden/keys/prod.keys";
      flakePath = prodKeysFilePath;
    })
  ];
}
