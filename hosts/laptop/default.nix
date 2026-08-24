{pkgs, ...}: {
  imports = [
    ./hardware.nix
  ];

  environment.systemPackages = with pkgs; [
    lisgd
    wvkbd
  ];

  services.iio-niri.enable = true;

  # for battttttttttttttery show in dms-shell
  services.upower = {
    enable = true;
  };

  modules = {
    core = {
      user = "user";
      headless = false;

      gpu = {
        intel.enable = true;
      };

      cpu.intel = true;

      zram = {
        enable = true;
        percent = 200;
      };
    };

    de = {
      niri.enable = true;
    };

    packages = {
      cli = {
        nvim.enable = true;

        dev = {
          buildtools = true;
          langs = {
            bundles.functional = false;

            cpp = true;
            go = true;
            haskell = false;
            java = true;
            lua = true;
            node = true;
            perl = false;
            php = false;
            python = true;
            ruby = false;
            rust = true;
            zig = true;
          };
        };
      };
      gui = {
        enable = true;
        zed.enable = true;
        winboat.enable = false;
        blender.enable = false;
        obs.enable = false;
      };
      lsp = {
        base = true;
        heavy = false;
      };
    };

    services = {
      avahi.enable = true;
      syncthing.enable = true;
      v2raya.enable = true;
    };
  };
}
