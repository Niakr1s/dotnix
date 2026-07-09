# Distrobox uses podman, so I put it here.
{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    distrobox
  ];
}
