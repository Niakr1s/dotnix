{pkgs, ...}: let
  onscreen-keyboard-enable = pkgs.writeShellScript "screen-keyboard-enable" ''
    #!/usr/bin/env bash

    gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true
    echo "$(date): screen-keyboard-enabled: completed with exit-code $?"
  '';
in {
  systemd.user.services.my-cli-command = {
    enable = true;
    description = "Screen keyboard enable on startup";
    serviceConfig = {
      Type = "oneshot"; # This makes it run once and exit
      ExecStart = "${onscreen-keyboard-enable}";
      StandardOutput = "journal";
      StandardError = "journal";
    };
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"]; # Wait for session to be ready
  };
}
