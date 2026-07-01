{
  lib,
  pkgs,
  username,
  ...
}:
let
  lutris_conf = lib.replaceStrings [ "\n" ] [ "\\n" ] ''
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
    show_advanced_options = True
  '';
in
{
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
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
      ];
      protonPackages = [
        proton-ge-bin
        dwproton-bin
      ];
      winePackages = [
        # wineWow64Packages.stable # stable
        # wineWow64Packages.stagingFull # version with experimental features
        wineWow64Packages.waylandFull # native wayland support
      ];
      runners = {
        linux = {
          settings = {
            system = {
              gamemode = false;
              mangohud = true;
            };
          };
        };
        wine = {
          settings = {
            system = {
              env = {
                PROTON_ENABLE_HDR = "0";
                PROTON_ENABLE_WAYLAND = "0";
                PROTON_DLSS_UPGRADE = "0";
                UMU_RUNTIME_UPDATE = "0"; # Disable umu runtime updates
                # PROTON_LARGE_ADDRESS_AWARE = "1"; # This is enabled by default. Disabling this may help with installing repacks.
              };
              gamemode = false;
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
}
