# Installation with `disko`

Warning: all data on your disk will be destroyed, so proceed carefully.

1. Download `disko-config.nix` to `/tmp`.

2. In `disko-config.nix`: set `disk.main.device` to your device (e.g.
   `/dev/sda`). Use `lsblk` command.

3. Run
   `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/disk-config.nix`.
   This will format and mount partitions.

4. Run `nixos-generate-config --no-filesystems --root /mnt`. This will generate
   configuration inside `/mnt/etc/nixos`.

5. Move the config to `/mnt/etc/nixos`:
   `mv /tmp/disk-config.nix /mnt/etc/nixos`.

6. Add the following to `/mnt/etc/nixos/configuration.nix`:

```nix
imports =
[ # Don't remove the results of the hardware scan
  ./hardware-configuration.nix
  # Add this two lines
  "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
  ./disk-config.nix
];
```

7. Change this in `/mnt/etc/nixos/configuration.nix`:

```
# Comment or remove this
# boot.loader.systemd-boot.enable = true;
# boot.loader.efi.canTouchEfiVariables = true;

boot = {
  loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;

    # ZFS needs this
    mirroredBoots = [
      { devices = [ "nodev" ]; path = "/boot"; }
    ];
  };
  # ZFS need this
  networking.hostId = "<output of 'head -c 8 /etc/machine-id'>";
};
```

8. You'll probably need to edit a bit `configuration.nix`: add correct user and
   add some programs for him (`vim`, `git`).

9. When you are ready, hit the button:

```
nixos-install
ENTER ROOT PASSWORD HERE
reboot
```
