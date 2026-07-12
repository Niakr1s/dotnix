{
  pkgs,
  username,
  hostname,
  flakeLib,
  ...
}:
{
  imports = [
    ./dms.nix

    (flakeLib.mkHomeLink ".config/niri/config.kdl")
    (flakeLib.mkHomeLink ".config/niri/${hostname}.kdl")
  ];

  programs.niri = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  security.polkit.enable = true; # polkit
  # services.gnome.gnome-keyring.enable = true; # secret service
}
