{
  pkgs,
  flakeDir,
  ...
}:
let
  command = "${pkgs.docker}/bin/docker compose --file ${flakeDir}/home/.config/winapps/compose.yaml";
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
