{username, ...}: {
  home-manager.users.${username} = {
    home.shellAliases = {
      hdd4 = "sudo cryptsetup luksOpen /dev/disk/by-uuid/5985a2f1-a9ab-4e9f-ae19-280685145e02 hdd4 && sudo mount /dev/mapper/hdd4 /data/hdd4";
      hdd20 = "sudo cryptsetup luksOpen /dev/disk/by-uuid/3b5448d2-3780-4cee-8529-caec12d1055e hdd20 && sudo mount /dev/mapper/hdd20 /data/hdd20";
      hdd24 = "sudo cryptsetup luksOpen /dev/disk/by-uuid/fabfb454-6de2-412d-8bc7-b56a849c77c7 hdd24 && sudo mount /dev/mapper/hdd24 /data/hdd24";
    };
  };
}
