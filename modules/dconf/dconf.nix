{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  hostname,
  username,
  home-manager,
  ...
}: let
in {
  home-manager.users.${username} = {lib, ...}: {
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

        "org/gnome/TextEditor" = {
          show-line-numbers = true;
          tab-width = lib.hm.gvariant.mkUint32 2;
          indent-width = -1;
          restore-session = false;
        };

        "org/gnome/shell" = {
          favorite-apps = [
            "org.gnome.Console.desktop"
            "org.gnome.Nautilus.desktop"
            "firefox.desktop"
            # "mpv.desktop"
            "io.github.celluloid_player.Celluloid.desktop"
            "startcenter.desktop"
            "org.telegram.desktop.desktop"
            "net.lutris.Lutris.desktop"
          ];
        };

        "org/gnome/shell/keybindings" = {
          toggle-message-tray = [];
          focus-active-notification = [];
          toggle-quick-settings = [];
          restore-shortcuts = [];
          # toggle-application-view = ["<Super>d"]; # not needed: press twice <Super>
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

        ### Nautilus
        "org/gtk/gtk4/settings/file-chooser" = {
          sort-directories-first = true;
          show-hidden = false;
        };

        "org/gnome/nautilus/preferences" = {
          default-folder-viewer = "list-view";
          show-create-link = true;
          show-delete-permanently = true;
          date-time-format = "detailed";
        };
        "org/gnome/nautilus/list-view" = {
          use-tree-view = true;
        };
        "org/gnome/nautilus/icon-view" = {
          # captions = ["none" "none" "none"];
          # captions = ["owner" "group" "permissions"];
          captions = ["size" "date_modified" "none"];
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
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          name = "Console";
          command = "kgx";
          binding = "<Super>Return";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          name = "Files";
          command = "nautilus";
          binding = "<Super>e";
        };

        "org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-ac-type = lib.mkDefault "nothing";
          sleep-inactive-ac-timeout = lib.mkDefault "900"; # in seconds
          power-button-action = "nothing";
        };

        "org/gnome/mutter" = {
          check-alive-timeout = lib.hm.gvariant.mkUint32 60000; # in milliseconds
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

          # Disable move to monitors
          move-to-monitor-down = [];
          move-to-monitor-up = [];
          move-to-monitor-left = lib.mkDefault [];
          move-to-monitor-right = lib.mkDefault [];

          # Move to workspaces
          move-to-workspace-left = ["<Shift><Super>bracketleft"];
          move-to-workspace-right = ["<Shift><Super>bracketright"];
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
          switch-to-workspace-left = ["<Super>bracketleft"];
          switch-to-workspace-right = ["<Super>bracketright"];

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

        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-schedule-from = 20.0;
          night-light-schedule-to = 7.0;
          night-light-temperature = 4700;
        };

        "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
          font = "JetBrainsMono Nerd Font 10";
          use-system-font = false;
        };

        # Gnomw wallpaper
        "org/gnome/desktop/background" = {
          picture-uri = "file:///home/${username}/.config/.wallpaper";
          picture-uri-dark = "file:///home/${username}/.config/.wallpaper";
          primary-color = "#3465a4";
          secondary-color = "#000000";
          color-shading-type = "solid";
          picture-options = "zoom";
        };
        "org/gnome/desktop/screensaver" = {
          picture-uri = "file:///home/${username}/config/.wallpaper";
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
        "org/gnome/desktop/peripherals/touchpad" = {
          click-method = "areas";
        };
        "org/gnome/Console" = {
          # last-window-size = mkTuple [1024 1024];
          # restore-window-size = true;
        };
      };
    };
  };
}
