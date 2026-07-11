{
  lib,
  pkgs,
  username,
  selectedWine,
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
    auto_update_runtime = True
    width = 1280
    height = 720
    maximized = False
    selected_category = category:favorite
    ignored_supported_lutris_verison = 0.5.22
    show_advanced_options = True
  '';
  proton = {
    ge = pkgs.unstable.proton-ge-bin;
    dw = pkgs.unstable.dwproton-bin;
    cachyos = pkgs.nur.repos.vladexa.proton-cachyos-v3;
    # cachyos = pkgs.nur.repos.forkprince.proton-cachyos-v3-bin;
  };
in
{
  home-manager.users.${username} = {
    # lutris
    programs.lutris = {
      enable = true;
      extraPackages = with pkgs; [
        winetricks
        gamescope
        gamemode
        umu-launcher
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
      ];
      defaultWinePackage = proton.cachyos;
      protonPackages = with proton; [
        ge
        dw
        cachyos
      ];
      winePackages = [
        selectedWine
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
                PROTON_DXVK_LOWLATENCY = "0"; # Activate low latency patch for proton-cachyos
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
