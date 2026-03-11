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
    devName, # last part of /dev/<device name>, e.g sdd2 of /dev/sdd2
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
        "${aliasName}_mount" = "cat /run/secrets/${sopsPath} | sudo veracrypt --text --stdin --non-interactive --pim=0 --protect-hidden=no /dev/${devName} ${mountPoint}";
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
      devName = "sdb2";
      sopsPath = "desktop/veracrypt/hdd4_pass";
      aliasName = "hdd4";
      mountPoint = "/data/hdd4";
    })
    (mkHdd {
      devName = "sdd2";
      sopsPath = "desktop/veracrypt/hdd20_pass";
      aliasName = "hdd20";
      mountPoint = "/data/hdd20";
    })
  ];
in
  lib.foldl lib.recursiveUpdate {} hddConfigs
