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
  mkHdd = devName: sopsPath: aliasName: mountPoint: {
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
    (mkHdd "sdb2" "desktop/veracrypt/hdd4_pass" "hdd4" "/data/hdd4")
    (mkHdd "sdd2" "desktop/veracrypt/hdd20_pass" "hdd20" "/data/hdd20")
  ];
in
  lib.foldl lib.recursiveUpdate {} hddConfigs
