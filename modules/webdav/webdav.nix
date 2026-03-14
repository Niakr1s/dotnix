{
  inputs,
  config,
  username,
  pkgs,
  ...
}: let
  webdavSopsPath = "common/webdav";
  url = "https://webdav.cloud.mail.ru";
  mountPoint = "/data/mailru";
  uid = toString config.users.users.${username}.uid;
  gid = toString config.users.groups.users.gid;
in {
  # https://blog.tiserbox.com/posts/2024-02-23-mounting-webdav-folder-in-nix-os.html
  # https://internet-lab.ru/cloud_mail_ru_webdaw_linux

  environment.systemPackages = with pkgs; [
    davfs2
  ];

  services.davfs2 = {
    enable = true;
    settings = {
      globalSection = {
        use_locks = false;
      };
    };
  };

  users.users.${username}.extraGroups = ["dav_group"];

  home-manager.users.${username} = {
    home.shellAliases = {
      mailru_mount = "sudo mount -t davfs ${url} ${mountPoint} -o uid=${uid},gid=${gid}";
      mailru_umount = "sudo umount ${mountPoint}";
      mailru = "cd ${mountPoint}";
    };
  };
  systemd.tmpfiles.rules = [
    "d ${mountPoint} 700 ${username} users - -"
  ];

  sops.secrets."${webdavSopsPath}" = {
    mode = "0600";
    path = "/etc/davfs2/secrets";
  };

  # TODO: It won't work at boot, should investigate
  # systemd.mounts = [
  #   {
  #     enable = true;
  #     description = "Webdav mailru";
  #     after = ["network-online.target"];
  #     wants = ["network-online.target"];
  #
  #     what = "${url}";
  #     where = "${mountPoint}";
  #     options = "uid=${uid},gid=${gid},file_mode=0664,dir_mode=2775";
  #     type = "davfs";
  #     mountConfig.TimeoutSec = 15;
  #   }
  # ];
}
