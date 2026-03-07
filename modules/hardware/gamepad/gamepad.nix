{
  inputs,
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  hostname,
  username,
  ...
}: let
  # Here are
  vendor = "045e";
  product = "028e";
in {
  # these are unneeded, remain here just for reference
  # boot.initrd.kernelModules = ["usbhid" "joydev" "xpad"];

  boot.kernelParams = [
    "usbcore.autosuspend=120" # seems it didn't work, but let it be here nevertheless
  ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="${vendor}", ATTR{idProduct}=="${product}", ATTR{power/control}="on"
  '';

  # Turn off gnome profiles daemon
  services.power-profiles-daemon.enable = false;
  # Turn on tlp daemon
  services.tlp = {
    enable = true;
    settings = {
      USB_DENYLIST = "${vendor}:${product}";
    };
  };

  # These seems are for xbox one controller, didn't needed for xbox 360
  # hardware.xone.enable = true;
  # hardware.xpadneo.enable = true;
}
