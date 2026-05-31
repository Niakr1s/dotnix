{...}: {
  services.displayManager.defaultSession = "niri";

  services.displayManager.gdm = {
    enable = true;
  };
}
