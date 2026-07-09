{
  pkgs,
  flakeLib,
  ...
}: let
  # Docker image configuration
  dockerImage = "habsaec/inpx-library-server:1.7.1@sha256:9696f9afd770a1ac659e2a4fb881f53260698a81b5a8084f5d1b6f84f7740437";
  containerName = "flibusta";

  # Base directories
  flibustaDir = "/data/hdd4/Flibusta";
  dataDir = "/data/hdd4/Flibusta/data";

  port = 8177;

  dockerCmd = "${pkgs.podman}/bin/podman";
  dockerRun = ''
    ${dockerCmd} run -d \
      --name ${containerName} \
      -p ${toString port}:3000 \
      -v ${flibustaDir}:/library:ro \
      -v ${dataDir}:/app/data \
      ${dockerImage}
  '';
in {
  imports = [
    (flakeLib.localhostReverseProxy "flibusta" port)
  ];

  systemd.user.services.flibusta = {
    description = "Flibusta library";
    # after = ["docker.service"];

    # I comment this out to not allow service to start after restart
    # wantedBy = ["default.target"];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p ${dataDir}"
        "${dockerCmd} pull ${dockerImage}"
      ];
      ExecStart = "${dockerRun}";
      ExecStop = "${dockerCmd} stop ${containerName}";
      ExecStopPost = "${dockerCmd} rm ${containerName}";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      port
    ];
  };
}
