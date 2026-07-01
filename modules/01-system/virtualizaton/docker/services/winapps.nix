{
  pkgs,
  flakeDir,
  username,
  ...
}:
let
  compose =
    # Official versions: 11l, 11i, 10l, 10i
    # Custom versions: tiny11, core11
    version:
    pkgs.writeText "winapps.yaml" ''
      # For documentation, FAQ, additional configuration options and technical help, visit: https://github.com/dockur/windows

      name: "winapps" # Docker Compose Project Name.
      services:
        windows:
          image: ghcr.io/dockur/windows:5.16
          container_name: WinApps # Created Docker VM Name.
          environment:
            # Version of Windows to configure. For valid options, visit:
            # https://github.com/dockur/windows?tab=readme-ov-file#how-do-i-select-the-windows-version
            # https://github.com/dockur/windows?tab=readme-ov-file#how-do-i-install-a-custom-image
            VERSION: "${version}" # LTSC
            RAM_SIZE: "4G" # RAM allocated to the Windows VM.
            CPU_CORES: "6" # CPU cores allocated to the Windows VM.
            DISK_SIZE: "64G" # Size of the primary hard disk.
            USERNAME: "bill" # Edit here to set a custom Windows username. The default is 'MyWindowsUser'.
            PASSWORD: "gates" # Edit here to set a password for the Windows user. The default is 'MyWindowsPassword'.
            HOME: "/home/${username}" # Set path to Linux user home folder.
          ports:
            # Map '8006' on Linux host to '8006' on Windows VM --> For VNC Web Interface @ http://127.0.0.1:8006.
            - "127.0.0.1:8006:8006"
            # Map '3389' on Linux host to '3389' on Windows VM --> For Remote Desktop Protocol (RDP).
            - "127.0.0.1:3389:3389/tcp"
            - "127.0.0.1:3389:3389/udp"
            # Uncomment the next two lines and comment out the two above to expose RDP to the local network.
            # - 3389:3389/tcp
            # - 3389:3389/udp
          cap_add:
            - NET_ADMIN # Add network permission
          stop_grace_period: 120s # Wait 120 seconds before sending SIGTERM when attempting to shut down the Windows VM.
          restart: on-failure # Restart the Windows VM if the exit code indicates an error.
          volumes:
            - /data/hdd1/VMs/winapps/${version}:/storage # Mount volume 'data' to use as Windows 'C:' drive.
            - /home/${username}:/shared # Mount Linux user home directory @ '\\host.lan\Data'.
            - /data:/shared2
            #- /tmp/oem:/oem # Enables automatic post-install execution of 'oem/install.bat', applying Windows registry modifications contained within 'oem/RDPApps.reg'.
            #- /path/to/windows/install/media.iso:/custom.iso # Uncomment to use a custom Windows ISO. If specified, 'VERSION' (e.g. 'tiny11') will be ignored.
          devices:
            - /dev/kvm # Enable KVM.
            - /dev/net/tun # Enable tuntap
    '';
  command = "${pkgs.docker}/bin/docker compose --file ${compose "core11"}";
in
{
  systemd.user.services.winapps = {
    description = "Winapps container";
    after = [ "docker.service" ];

    # I comment this out to not allow service to start after restart
    # wantedBy = ["default.target"];

    serviceConfig = {
      Type = "simple";
      RemainAfterExit = true;
      ExecStart = "${command} up";
      ExecStop = "${command} down";
    };
  };
}
