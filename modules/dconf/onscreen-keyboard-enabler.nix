{pkgs, ...}: let
  screen-keyboard-enable = pkgs.writeShellScript "screen-keyboard-enable" ''
    #!/usr/bin/env bash

    sleep 5
    ${pkgs.dbus}/bin/dbus-monitor --session "type='signal',interface='org.gnome.ScreenSaver'" | \
    while read -r line; do
        case "$line" in
            *"boolean true"*)
                ${pkgs.glib}/bin/gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true
                echo "Screen locked - on-screen keyboard finished with exit code $?"
                exit "$?"
                ;;
        esac
    done
  '';
in {
  systemd.user.services.screen-keyboard-enable = {
    enable = true;
    description = "Screen keyboard enable on startup";
    serviceConfig = {
      Type = "exec";
      ExecStart = "${screen-keyboard-enable}";
      Restart = "always";
      RestartSec = 5;
      Environment = "DISPLAY=:0";
      StandardOutput = "journal";
      StandardError = "journal";
    };
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"]; # Wait for session to be ready
  };
}
