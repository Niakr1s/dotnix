# Installation

## Installation with `disko`

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
  ./disko-config.nix
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
};
```

8. For ZFS, you'll need to generate a new hostId or take an existing one from
   your configuration. Don't change this hostId, otherwise the system won't be
   able to mount your disks.

```
# ZFS need this
networking.hostId = "<output of 'head -c 8 /etc/machine-id'>";
```

9. You'll probably need to edit a bit `configuration.nix`: add correct user and
   add some programs for him (`vim`, `git`).

10. When you are ready, hit the button:

```
nixos-install
ENTER ROOT PASSWORD HERE
reboot
```

## Reinstallation

Probably you just need to run
`nixos-install --flake github:niakr1s/dotnix#somehost`. Untested yet. Don't know
whether it'll run `disko` module correctly. If not, partition disks with `disko`
as in [Installation](#installation-with-disko) part, aftewards run the
`nixos-install` command.

# Hardware

## Gamepad

I've encountered a strange behaviour with Flydigi Dune Fox gamepad. After I
reset it, I couldn't actually connect it to it's dongle again. I've tried all
available methods for 3 hours long, after actually the gamepad connected. Final
research is in `modules/hardware/gamepad/gamepad.nix` file.

But it's so strange, I commented out imports from this file, and gamepad
actually continued to work. Seems, that if gamepad is connected to it's dongle,
it stays working.

Another strange thing - `dmesg` gave me such output always:

```
[  216.551975] usb 1-9.2: new full-speed USB device number 15 using xhci_hcd
[  216.627904] usb 1-9.2: New USB device found, idVendor=045e, idProduct=028e, bcdDevice= 1.10
[  216.627908] usb 1-9.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  216.627910] usb 1-9.2: Product: Flydigi Dune Fox
[  216.627912] usb 1-9.2: Manufacturer: Flydigi
[  216.627913] usb 1-9.2: SerialNumber: 5EA2DE78
[  216.633525] input: Microsoft X-Box 360 pad as /devices/pci0000:00/0000:00:14.0/usb1/1-9/1-9.2/1-9.2:1.0/input/input28
[  218.176947] usb 1-9.2: USB disconnect, device number 15
```

so I thought, that the thing is that the dongle immediatly disconnects, but
after the gamepad connected, `dmesg` continued to give such output, so it's
seems a normal behaviour.

Btw, the gamepad connected while I was resetting the dongle for 10 seconds(a
tiny hole in it), and the gamepad was in search mode, but it worked after 10th
time I guess? So strange.

So if your gamepad is already connected to dongle - don't try to disconnect or
reset settings, because it will cost you a lot of time. But I don't regret
actually, I've learned a bit more about Linux.

# Software

## v2raya

You'll need a certain version of `v2raya` package to work it with `xhttp`. It's
already configured in this configuration via `nixos-unstable` overlay, so don't
mind it. Just login at `http://localhost:2017` and configure it.

My working configuration as of March 2026 looks like:

```
Transparent Proxy/System Proxy = 'On: Do not Split Traffic'
Transparent Proxy/System Proxy Implementation = 'redirect'
Traffic Splitting Mode of Rule Port = RoutingA
# Others options are default
```

and RoutingA configuration is simple:

```
default: proxy
```

Add this configuration and run service.

## qbittorrent

The service should work as a system service. The downloads will be placed in
`/srv/torrents` by default. Directory `/srv/torrents/autoload` is being watched
for new torrents, so users can put their files there and they will be downloaded
automatically.

## Lutris

If you don't want to waste brandwidth and disk space, be sure to disable auto
updates or runtime and wine, because the source of it will be provided by nixos.
So, make sure you have

```
wine-update-channel = self-maintained
auto_update_runtime = False
```

in your `~/.config/lutris/lutris.conf`
