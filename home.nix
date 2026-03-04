{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  ...
}: let
  unstablePkgs = import nixpkgs-unstable {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };
in {
  home.stateVersion = "25.11";

  home.username = "nea";
  home.homeDirectory = "/home/nea";

  home.packages = with pkgs; [
  ];

  imports = [
    inputs.nvf.homeManagerModules.default
    ./nvf.nix
  ];

  # Wallpaper
  xdg.configFile.".wallpaper".source = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/o5/wallhaven-o5k319.jpg";
    sha256 = "sha256-QcKntDg+YYSRxtwQeA+rahXGwxktcPwvyMy5GJoiNec=";
  };

  fonts.fontconfig = {
    enable = true;
    # antialiasing = true;
    # hinting = "slight"; # null or one of "none", "slight", "medium", "full"
    # subpixelRendering = "rgb"; # one of "rgb", "bgr", "vrgb", "vbgr", "none"
  };

  programs.zsh = {
    enable = true;

    shellAliases = {
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Niakr1s";
        email = "pavel2188@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };

  programs.mpv.enable = true;
  xdg.configFile."mpv" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/nea/.dotnix/config/mpv";
    recursive = true;
  };

  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  #   viAlias = true;
  #   vimAlias = true;
  #   withNodeJs = true;
  #   withPython3 = true;
  #   withRuby = true;
  # };

  # xdg.configFile."nvim" = {
  #   source = config.lib.file.mkOutOfStoreSymlink "/home/nea/.dotnix/config/nvim";
  #   recursive = true;
  # };

  xdg.configFile."MangoHud" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/nea/.dotnix/config/MangoHud";
    recursive = true;
  };

  # home.file."local/share/lutris/runners/wine.yml".source = config.lib.file.mkOutOfStoreSymlink "/path/to/your/wine.yml";

  programs.firefox = {
    enable = true;

    languagePacks = ["en-US"];

    profiles.default.extraConfig = ''
      // https://gist.github.com/lassekongo83/7026910c6a277d5d9cf37989d83e9f6d

      // Don't close window with last tab
      user_pref("browser.tabs.closeWindowWithLastTab", false);

      // Disable Firefox View
      user_pref("browser.tabs.firefox-view", false);

      // Disable disc cache
      user_pref("browser.cache.disk.enable", false);

      // Disable push notifications
      user_pref("dom.push.enabled", false);

      // Telemetry
      user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
      user_pref("browser.newtabpage.activity-stream.telemetry", false);
      user_pref("browser.ping-centre.telemetry", false);
      user_pref("toolkit.telemetry.archive.enabled", false);
      user_pref("toolkit.telemetry.bhrPing.enabled", false);
      user_pref("toolkit.telemetry.enabled", false);
      user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
      user_pref("toolkit.telemetry.newProfilePing.enabled", false);
      user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
      user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
      user_pref("toolkit.telemetry.unified", false);
      user_pref("toolkit.telemetry.updatePing.enabled", false);

      // PREF: Disable sending reports of tab crashes to Mozilla (about:tabcrashed), don't nag user about unsent crash reports
      user_pref("browser.tabs.crashReporting.sendReport", false);
      user_pref("browser.crashReports.unsubmittedCheck.enabled", false);

      // Ads
      user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
      user_pref("browser.newtabpage.activity-stream.showSponsored", false);
      user_pref("browser.vpn_promo.enabled", false);
      user_pref("browser.promo.focus.enabled", false);
    '';

    profiles.default.search = {
      force = true;
      default = "ddg";
      privateDefault = "ddg";

      engines = {
        "nix packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@np"];
        };

        "nix options" = {
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@no"];
        };

        "nixos wiki" = {
          urls = [
            {
              template = "https://wiki.nixos.org/w/index.php";
              params = [
                {
                  name = "search";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@nw"];
        };

        "my nixos" = {
          urls = [
            {
              template = "https://mynixos.com/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@nm"];
        };

        "youtube" = {
          urls = [
            {
              template = "https://www.youtube.com/results";
              params = [
                {
                  name = "search_query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = ["@yt"];
        };
      };
    };
  };

  dconf = {
    enable = true;
    settings = with lib.hm.gvariant; {
      "org/gnome/desktop/interface" = {
        accent-color = "blue";
        color-scheme = "prefer-dark";
        clock-show-seconds = true;
        clock-show-weekday = true;

        # Noto Sans for UI - clean and modern
        font-name = "Noto Sans 11";
        # Liberation for documents - professional and compatible
        document-font-name = "Liberation Serif 12";
        # JetBrains Mono Nerd Font for terminal - icons + readability
        monospace-font-name = "JetBrainsMono Nerd Font 10";
      };

      "org/gnome/shell" = {
        favorite-apps = [
          "org.gnome.Console.desktop"
          "org.gnome.Nautilus.desktop"
          "firefox.desktop"
          "net.lutris.Lutris.desktop"
        ];
      };

      "org/gnome/shell/keybindings" = {
        toggle-message-tray = [];
        focus-active-notification = [];
        toggle-quick-settings = [];
        restore-shortcuts = [];
        toggle-application-view = ["<Super>d"];
        shift-overview-down = [];
        shift-overview-up = [];
        show-screen-recording-ui = [];
        open-new-window-application-1 = [];
        open-new-window-application-2 = [];
        open-new-window-application-3 = [];
        open-new-window-application-4 = [];
        open-new-window-application-5 = [];
        open-new-window-application-6 = [];
        open-new-window-application-7 = [];
        open-new-window-application-8 = [];
        open-new-window-application-9 = [];
        switch-to-application-1 = [];
        switch-to-application-2 = [];
        switch-to-application-3 = [];
        switch-to-application-4 = [];
        switch-to-application-5 = [];
        switch-to-application-6 = [];
        switch-to-application-7 = [];
        switch-to-application-8 = [];
        switch-to-application-9 = [];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        help = [];
        logout = [];
        screenreader = [];
        magnifier = [];
        magnifier-zoom-in = [];
        magnifier-zoom-out = [];
        screensaver = ["<Alt><Super>l"];
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Console";
        command = "kgx";
        binding = "<Super>Return";
      };

      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
      };

      "org/gnome/mutter/keybindings" = {
        toggle-tiled-left = ["<Shift><Super>h"];
        toggle-tiled-right = ["<Shift><Super>l"];
      };

      "org/gnome/desktop/wm/keybindings" = {
        close = ["<Super>q"];
        minimize = [];
        maximize = [];
        unmaximize = [];
        begin-move = [];
        begin-resize = [];
        toggle-fullscreen = ["<Super>f"];
        toggle-maximized = ["<Shift><Super>f"];
        panel-run-dialog = ["<Alt><Super>d"];

        # Move to monitors
        move-to-monitor-down = [];
        move-to-monitor-up = [];
        move-to-monitor-left = ["<Shift><Super>bracketleft"];
        move-to-monitor-right = ["<Shift><Super>bracketright"];

        # Move to workspaces
        move-to-workspace-left = [];
        move-to-workspace-right = [];
        move-to-workspace-last = [];
        move-to-workspace-1 = ["<Shift><Super>1"];
        move-to-workspace-2 = ["<Shift><Super>2"];
        move-to-workspace-3 = ["<Shift><Super>3"];
        move-to-workspace-4 = ["<Shift><Super>4"];

        # Switch applications
        switch-applications = [];
        switch-applications-backward = [];

        # Switch system controls
        switch-panels = [];
        switch-panels-backward = [];

        # Switch system controls directly
        cycle-panels = [];
        cycle-panels-backward = [];

        # Switch to workspaces
        switch-to-workspace-1 = ["<Super>1"];
        switch-to-workspace-2 = ["<Super>2"];
        switch-to-workspace-3 = ["<Super>3"];
        switch-to-workspace-4 = ["<Super>4"];
        switch-to-workspace-last = [];
        switch-to-workspace-left = [];
        switch-to-workspace-right = [];

        # Switch windows
        switch-windows = [];
        switch-windows-backward = [];

        # Switch windows directly
        cycle-windows = ["<Super>Tab"];
        cycle-windows-backward = ["<Shift><Super>Tab"];

        # Switch windows of an app directly
        cycle-group = [];
        cycle-group-backward = [];

        # Switch windows of an application
        switch-group = [];
        switch-group-backward = [];
      };

      "org/gnome/shell" = {
        last-selected-power-profile = "perfomance";
        disable-user-extensions = false; # Optionally disable user extensions entirely
        enabled-extensions = [
          pkgs.gnomeExtensions.blur-my-shell.extensionUuid
          pkgs.gnomeExtensions.just-perfection.extensionUuid
          # pkgs.gnomeExtensions.forge.extensionUuid
        ];
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-schedule-from = 20.0;
        night-light-schedule-to = 7.0;
        night-light-temperature = 4700;
      };

      # Configure individual extensions
      "org/gnome/shell/extensions/blur-my-shell" = {
        brightness = 0.75;
        noise-amount = 0;
      };
      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        enable-all = true;
        blur = true;
        blacklist = [
          "Plank"
          "com.desktop.ding"
          "Conky"
        ];
      };

      # Forge config
      "org/gnome/shell/extensions/forge" = {
        focus-on-hover-enabled = false;
        move-pointer-focus-enabled = false;

        window-gap-size = 0;
        window-gap-size-increment = 0;
        window-gap-hidden-on-single = true;
      };
      "org/gnome/shell/extensions/forge/keybindings" = {
        window-gap-size-decrease = [];
        window-gap-size-increase = [];

        window-resize-bottom-decrease = [];
        window-resize-bottom-increase = [];
        window-resize-left-decrease = [];
        window-resize-left-increase = [];
        window-resize-right-decrease = [];
        window-resize-right-increase = [];
        window-resize-top-decrease = [];
        window-resize-top-increase = [];

        window-snap-center = [];
        window-snap-one-third-left = [];
        window-snap-one-third-right = [];
        window-snap-two-third-left = [];
        window-snap-two-third-right = [];

        window-move-down = ["<Super><Shift>j"];
        window-move-left = ["<Super><Shift>h"];
        window-move-right = ["<Super><Shift>l"];
        window-move-up = ["<Super><Shift>k"];

        window-swap-down = [];
        window-swap-left = [];
        window-swap-right = [];
        window-swap-up = [];
        # window-swap-down = ["<Super><Alt>j"];
        # window-swap-left = ["<Super><Alt>h"];
        # window-swap-right = ["<Super><Alt>l"];
        # window-swap-up = ["<Super><Alt>k"];

        window-swap-last-active = [];

        window-toggle-always-float = ["<Super>c"];
        window-toggle-float = [];

        # Layouts
        con-split-layout-toggle = ["<Super>v"];
        con-stacked-layout-toggle = ["<Super>s"];
        con-tabbed-layout-toggle = ["<Super>t"];

        con-split-horizontal = [];
        con-split-vertical = [];
        con-tabbed-showtab-decoration-toggle = [];

        workspace-active-tile-toggle = [];
        focus-border-toggle = [];
        prefs-open = [];
        prefs-tiling-toggle = [];
      };

      "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
        font = "JetBrainsMono Nerd Font 10";
        use-system-font = false;
      };

      # Gnomw wallpaper
      "org/gnome/desktop/background" = {
        picture-uri = "file:///home/nea/.config/.wallpaper";
        picture-uri-dark = "file:///home/nea/.config/.wallpaper";
        primary-color = "#3465a4";
        secondary-color = "#000000";
        color-shading-type = "solid";
        picture-options = "zoom";
      };
      "org/gnome/desktop/screensaver" = {
        picture-uri = "file:///home/nea/config/.wallpaper";
        primary-color = "#3465a4";
        secondary-color = "#000000";
        color-shading-type = "solid";
        picture-options = "zoom";
      };
      "org/gnome/desktop/privacy" = {
        remove-old-trash-files = true;
        old-files-age = 30;
        remove-old-temp-files = true;
        recent-files-max-age = 30;
      };
      "org/gnome/Console" = {
        # last-window-size = mkTuple [1024 1024];
        # restore-window-size = true;
      };
    };
  };
}
