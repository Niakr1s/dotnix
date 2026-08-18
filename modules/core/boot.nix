{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;

  headless = config.modules.core.headless;
in
{
  systemd.services.NetworkManager-wait-online.enable = false;
  boot = {
    tmp.cleanOnBoot = true;

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      timeout = 5;
    };
    plymouth = {
      enable = !headless;
      theme = "bgrt";
    };
    kernelParams = [
      "clearcpuid=514" # probable fix for errors in proton (umip: For now, expensive software emulation returns the result)
      "split_lock_detect=off" # probable fix for errors in proton(x86/split lock detection: took a split_lock trap at address)
      "usbcore.quirks=\"057e:2009:ik\"" # fix for gamepad
    ] ++ (lib.optionals (!headless) [
      "quiet"
      "splash"
      "udev.log_level=3"
    ]);
    initrd.systemd.enable = true;
  };
}
