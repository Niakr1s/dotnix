{
  pkgs,
  username,
  ...
}:
let
  custom-sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "purple_leaves";
  };
in
{
  environment.systemPackages = with pkgs.kdePackages; [
    custom-sddm-astronaut
    qtsvg
    qtmultimedia # Fixes the "module not installed" error
    qtvirtualkeyboard # Required if you need on-screen keyboard];
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      # compositor = "kwin";
    };

    theme = "sddm-astronaut-theme";

    extraPackages = with pkgs.kdePackages; [
      qtsvg
      qtmultimedia
      qtvirtualkeyboard # Required for virtual keyboard to actually work
    ];

    # This is the critical part that enables the virtual keyboard
    settings = {
      General = {
        GreeterEnvironment = "QT_IM_MODULE=qtvirtualkeyboard";
        InputMethod = "qtvirtualkeyboard"; # Tells SDDM to use Qt's virtual keyboard
      };
    };
  };
}
