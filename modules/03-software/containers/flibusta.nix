{
  flakeLib,
  username,
  ...
}:
let
  # Docker image configuration
  dockerImage = "habsaec/inpx-library-server:1.7.1@sha256:9696f9afd770a1ac659e2a4fb881f53260698a81b5a8084f5d1b6f84f7740437";

  # Base directories
  flibustaDir = "/data/hdd4/Flibusta";
  dataDir = "/data/hdd4/Flibusta/data";

  port = 8177;
in
{
  imports = [
    (flakeLib.localhostReverseProxy "flibusta" port)
  ];

  virtualisation.oci-containers.containers.flibusta = {
    image = "${dockerImage}";
    autoStart = false;
    podman.user = "${username}";

    ports = [ "${toString port}:3000" ];
    volumes = [
      "${flibustaDir}:/library:ro"
      "${dataDir}:/app/data"
    ];
  };
  networking.firewall = {
    allowedTCPPorts = [
      port
    ];
  };
}
