{
  config,
  lib,
  flakeLib,
  pkgs,
  ...
}: let
  cfg = config.modules.services.windows;

  browserPort = 8006;
  rdpPort = 3398;

  compose = ''
    name: windows
    services:
      windows:
        image: ghcr.io/dockur/windows:5.14
        container_name: windows
        environment:
          RAM_SIZE: 6G
          CPU_CORES: "8"
          DISK_SIZE: 32G
          USERNAME: bill
          PASSWORD: gates
          LANGUAGE: English
        devices:
          - /dev/kvm
          - /dev/net/tun
        cap_add:
          - NET_ADMIN
          - NET_RAW
        ports:
          - ${toString browserPort}:8006
          - ${toString rdpPort}:3389/tcp
          - ${toString rdpPort}:3389/udp
        volumes:
          - ${cfg.isoPath}:/custom.iso
          - ${workingDir}/storage:/storage
          ${
      if cfg.shared != null
      then "- ${cfg.shared}:/shared"
      else ""
    }
          ${
      if cfg.shared2 != null
      then "- ${cfg.shared2}:/shared2"
      else ""
    }
        restart: on-failure
        stop_grace_period: 2m
  '';
  composeFile = pkgs.writeText "windows.yml" compose;

  serviceName = "windows";
  workingDir = "/var/lib/${serviceName}";

  runCompose = action:
    pkgs.writeShellScript "windows-compose-${action}" ''
      export PATH="${lib.makeBinPath [pkgs.podman pkgs.podman-compose]}:$PATH"
      exec ${pkgs.podman-compose}/bin/podman-compose -f ${composeFile} ${action}
    '';
in {
  # Implement the service block if enabled
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        virtualisation.containers.enable = true;
        virtualisation.podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };

        environment.systemPackages = with pkgs; [
          podman
          podman-compose
        ];

        systemd.services.${serviceName} = {
          description = "Dockurr Windows Container via Podman (Manual Start)";
          after = ["podman.service" "podman.socket"];
          wants = ["podman.service"];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            WorkingDirectory = "${workingDir}";
            StateDirectory = "${serviceName}";

            ExecStart = "${runCompose "up -d"}";
            ExecStop = "${runCompose "down"}";
          };
        };
      }
      (flakeLib.localhostReverseProxy "${serviceName}" browserPort {})
    ]
  );
}
