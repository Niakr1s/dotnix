{
  lib,
  pkgs,
  username,
  ...
}: let
  lutris_conf = lib.replaceStrings ["\n"] ["\\n"] ''
    [services]
    gog = True
    egs = True
    ea_app = True
    ubisoft = True
    steam = True

    [lutris]
    library_ignores =
    migration_version = 15
    wine-update-channel = self-maintained
    auto_update_runtime = False
    width = 1280
    height = 720
    maximized = False
    selected_category = category:favorite
    ignored_supported_lutris_verison = 0.5.22
  '';
in {
  home-manager.users.${username} = {
    # lutris
    programs.lutris = with pkgs; {
      enable = true;
      defaultWinePackage = proton-ge-bin;
      extraPackages = [
        winetricks
        gamescope
        gamemode
        umu-launcher
      ];
      protonPackages = [
        proton-ge-bin
      ];
      winePackages = [
        proton-ge-bin
        # wineWow64Packages.waylandFull # native wayland support (unstable)
      ];
      runners = {
        wine = {
          settings = {
            system = {
              env = {
                PROTON_ENABLE_HDR = "1";
                PROTON_ENABLE_WAYLAND = "1";
              };
              gamescope = false;
              gamescope_hdr = false;
              mangohud = true;
            };
          };
        };
      };
    };
  };
  systemd.tmpfiles.rules = [
    "f+ /home/${username}/.config/lutris/lutris.conf 644 ${username} users - ${lutris_conf}"
  ];
  environment.systemPackages = with pkgs; [
    vulkan-tools
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
  ];
}
