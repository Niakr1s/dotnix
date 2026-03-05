# This is my nixos dotfiles for future me

## Installation

### A new system on a new host

Consider reading the [article](https://qfpl.io/posts/installing-nixos/) about
installing nixos to properly configure disks and enable encryption.

Then there is a great
[article](https://www.tonybtw.com/tutorial/nixos-from-scratch/) from TonyBtw
about how to use flakes.

Boot with minimal iso. Next, configure network with `nmtui`.

Remove all partitions from your disk and configure partitions

```
-- Identify the disk to install NixOS on - something like /dev/nvme0n1 or /dev/sda.
-- We'll refer to it as $DISK.
# lsblk

-- Open gdisk on the disk we're installing on
# gdisk $DISK 

-----------------------
-- BEGIN GDISK COMMANDS

-- print the partitions on the disk
Command: p

-- Delete a partition. Select the partition number when prompted.
-- Repeat for all partitions.
Command: d

-- Create the EFI boot partition
Command: n
Partition number: 1
First sector: <enter for default>
Last sector: +1G       --  make a 1 gigabyte partition
Hex code or GUID: ef00 -- this is the EFI System type

-- Create the LVM partition
Command: n
Partition number: 2
First sector: <enter for default>
Last sector: <enter for default - rest of disk>
Hex code or GUID: 8e00 -- Linux LVM type

-- Write changes and quit
Command: w

-- END GDISK COMMANDS
---------------------
```

Setup encryption on second partition. This is the second partition that we
created above - so should be something like /dev/nvme0n1p2 or /dev/sda2. We’ll
refer to it as $LVM_PARTITION below. Note that our boot partition won’t be
encrypted.

```
-- You will be asked to enter your passphrase - DO NOT FORGET THIS
# cryptsetup luksFormat $LVM_PARTITION

-- Decrypt the encrypted partition and call it nixos-enc. The decrypted partition
-- will get mounted at /dev/mapper/nixos-enc
# cryptsetup luksOpen $LVM_PARTITION nixos-enc
    
-- Create the LVM physical volume using nixos-enc
# pvcreate /dev/mapper/nixos-enc 

-- Create a volume group that will contain our root and swap partitions
# vgcreate nixos-vg /dev/mapper/nixos-enc

-- Create a swap partition that is 16G in size - the amount of RAM on this machine
-- Volume is labeled "swap"'
# lvcreate -L 16G -n swap nixos-vg

-- Create a logical volume for our root filesystem from all remaining free space.
-- Volume is labeled "root"
# lvcreate -l 100%FREE -n root nixos-vg
```

Now create our filesystems

```
-- Create a FAT32 filesystem on our boot partition
# mkfs.vfat -n boot $BOOT_PARTITION

-- Create an ext4 filesystem for our root partition
# mkfs.ext4 -L nixos /dev/nixos-vg/root

-- Tell our swap partition to be a swap
# mkswap -L swap /dev/nixos-vg/swap

-- Turn the swap on before install
# swapon /dev/nixos-vg/swap
```

Mount filesystems and prepare for install. The snippet below uses
$BOOT_PARTITION as a placeholder for the UEFI boot partition we created earlier.
This was the first partition on the disk, and will probably be something like
/dev/sda1 or /dev/nvme0n1p1.

```
# mount /dev/nixos-vg/root /mnt
# mkdir /mnt/boot
# mount $BOOT_PARTITION /mnt/boot
```

Generate our initial config

```
# nixos-generate-config --root /mnt
```

Add encryption settings to `/etc/nixos/hardware-configuration.nix`. Change
device path to $LVM_PARTITION

```
boot.initrd.luks.devices = {
  root = { 
    device = "/dev/${LVM_PARTITION}";
    preLVM = true;
  };
};
```

Uncomment user settings in `/etc/nixos/configuration.nix`. This config uses
`nea` as username, so do this.

```
users.users.nea = {
  isNormalUser = true;
  extraGroups = [ "wheel" ];
  packages = with pkgs; [
    git # Add this to be able to clone this configuration afterwards
    vim # Is useful to edit files
  ];
};
```

Pull the trigger

```
# nixos-install
-- IT'LL ASK YOU FOR YOUR ROOT PASSWORD NOW - DON'T FORGET IT
# reboot
```

Setup user password after reboot. Login as `root` and run `passwd $USER`.

Login as `nea` and clone this repository to `/home/nea/.dotnix` directory. You
will probably need to configure network again with `nmtui`.

```
# git clone --recurse-submodules ${this repo} /home/nea/.dotnix
```

Copy `/etc/nixos/hardware-configuration` to your host hardware configuration, or
modify it if needed. Note: If `hardware-configuration.nix` was not in git, you
should `git add` it, otherwise it will error you.

AFterwards, run `sudo nixos-rebuild switch --flake /home/nea/.dotnix#desktop`
and you are gtg.

### Reinstallation

Keep in mind, that you already have `hardware-configuration.nix`, so you'll
probably want to reuse it.

## Hardware

### Gamepad

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

## Software

### v2raya

You'll need a certain version of `v2raya` package to work it with `xhttp`. It's
already configured in this configuration via `nixos-unstable` overlay, so don't
mind it. Just login at `http://localhost:2017` and configure it.

My working configuration as of March 2026 looks like:

```
Transparent Proxy/System Proxy = 'On: Do not Split Traffic'
Transparent Proxy/System Proxy Implementation = 'redirect'
Traffic Splitting Mode of Rule Port = RoutingA
Prevent DNS Spoofing = Off
Special Mode = Off
TCPFastOpen = Keep Default
```

and RoutingA configuration is simple:

```
default: proxy
```

Add this configuration and run service.
