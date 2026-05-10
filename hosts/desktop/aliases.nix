{
  username,
  lib,
  ...
}: let
  luksMount = uuid: label: {
    home-manager.users.${username}.home.shellAliases.${label} = "sudo cryptsetup luksOpen /dev/disk/by-uuid/${uuid} ${label} && sudo mount /dev/mapper/${label} /data/${label}";
  };
  luksMounts = [
    (luksMount "5985a2f1-a9ab-4e9f-ae19-280685145e02" "hdd4")
    (luksMount "3b5448d2-3780-4cee-8529-caec12d1055e" "hdd20")
    (luksMount "fabfb454-6de2-412d-8bc7-b56a849c77c7" "hdd24")
  ];

  luksUmount = label: {
    home-manager.users.${username}.home.shellAliases."${label}u" = "sudo umount /data/${label} && sudo cryptsetup luksClose ${label}";
  };
  luksUmounts = [
    (luksUmount "hdd4")
    (luksUmount "hdd20")
    (luksUmount "hdd24")
  ];
in
  lib.foldl lib.recursiveUpdate
  {}
  (luksMounts ++ luksUmounts)
