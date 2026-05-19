{pkgs, ...}: let
  # Override wvkbd to build the desktop layout
  wvkbd-desktop = pkgs.wvkbd.overrideAttrs (oldAttrs: {
    makeFlags = (oldAttrs.makeFlags or []) ++ ["LAYOUT=deskintl"];

    # Optional: Add compile-time parameters for full hardware features
    # SHIFT_SPACE_IS_TAB: Makes Shift+Space act as Tab
    # buildFlags = ["SHIFT_SPACE_IS_TAB=1"];
  });
in {
  environment.systemPackages = [wvkbd-desktop];
}
