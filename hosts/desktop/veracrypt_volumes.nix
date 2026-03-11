{
  inputs,
  config,
  lib,
  pkgs,
  hostname,
  unstablePkgs,
  username,
  home-manager,
  flakeDir,
  ...
}: let
  mkHdd = {
    dev, # path to a device (e.g /dev/blahblahblha)
    sopsPath, # same path as in secrets.yaml
    aliasName, # prefix of aliases
    mountPoint, # mount point
  }: {
    sops.secrets = {
      # This is the actual specification of the secrets.
      "${sopsPath}" = {
        mode = "0440";
        owner = config.users.users.${username}.name;
        group = config.users.users.${username}.group;
      };
    };

    home-manager.users.${username} = {
      home.shellAliases = {
        "${aliasName}_mount" = "cat /run/secrets/${sopsPath} | sudo veracrypt --text --stdin --non-interactive --pim=0 --protect-hidden=no ${dev} ${mountPoint}";
        "${aliasName}_umount" = "sudo veracrypt -d ${mountPoint}";
        "${aliasName}" = "cd ${mountPoint}";
      };
    };
    systemd.tmpfiles.rules = [
      "d ${mountPoint} 700 ${username} users - -"
    ];
  };
  hddConfigs = [
    (mkHdd {
      dev = "/dev/disk/by-partuuid/3f4eb362-0061-477b-94cf-4b6e000c7d1d";
      sopsPath = "desktop/veracrypt/hdd4_pass";
      aliasName = "hdd4";
      mountPoint = "/data/hdd4";
    })
    (mkHdd {
      dev = "/dev/disk/by-partuuid/ab10963f-c6e8-4316-9065-79ad507cd22e";
      sopsPath = "desktop/veracrypt/hdd20_pass";
      aliasName = "hdd20";
      mountPoint = "/data/hdd20";
    })
  ];
in
  lib.foldl lib.recursiveUpdate {} hddConfigs
