{
  pkgs,
  flakeLib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    w3m
  ];

  imports = [
    # (flakeLib.mkHomeLink ".w3m/keymap")
    (flakeLib.mkHomeLink ".w3m/config")
  ];
}
