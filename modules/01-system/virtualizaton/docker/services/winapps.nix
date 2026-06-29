{
  pkgs,
  username,
  ...
}:
let
  command = "${pkgs.docker}/bin/docker compose --file /home/${username}/.config/winapps/compose.yaml";
in
{
  systemd.user.services.winapps = {
    description = "Winapps container";
    after = [ "docker.service" ];

    # I comment this out to not allow service to start after restart
    # wantedBy = ["default.target"];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = [
        # "${pkgs.coreutils}/bin/mkdir -p ${dataDir}"
        # "${pkgs.docker}/bin/docker pull ${dockerImage}"
      ];
      ExecStart = "${command} up --detach";
      ExecStop = "${command} down";
    };
  };
}
