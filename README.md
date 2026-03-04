# This is my nixos dotfiles for future me

## Installation

Consider reading the [article](https://qfpl.io/posts/installing-nixos/) about
installing nixos to properly configure disks and enable encryption.

Then there is a great
[article](https://www.tonybtw.com/tutorial/nixos-from-scratch/) from TonyBtw
about how to use flakes.

This configuration should be cloned into `/home/nea/.dotnix` directory.
AFterwards, run `sudo nixos-rebuild switch --flake /home/nea/.dotnix#desktop`
and you are gtg.

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

So if your gamepad is already connected to dongle - don't try to disconnect or
reset settings, because it will cost you a lot of time. But I don't regret
actually, I've learned a bit more about Linux.
