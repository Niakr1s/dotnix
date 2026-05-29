{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    unstable.shadps4
  ];
}
