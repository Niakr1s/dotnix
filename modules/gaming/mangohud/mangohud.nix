{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  stateVersion,
  hostname,
  username,
  home-manager,
  ...
}: let
in {
  home-manager.users.${username} = {
    # mangohud
    programs.mangohud = {
      enable = true;
      settings = {
        fps_limit = [165 30 60];
        vsync = 0; # 0 = adaptive; 1 = off; 2 = mailbox; 3 = on
        time = true;
        time_no_label = true;
        time_format = "%F %T";
        gpu_stats = true;
        gpu_temp = true;
        cpu_stats = true;
        cpu_temp = true;
        fps = true;
        frame_timing = 0;
        font_size = 16;
        text_outline = true;
        width = 0;
        background_alpha = 0.4;

        ### Change toggle keybinds for the hud & logging
        # toggle_hud=Shift_R+F12
        # toggle_hud_position=Shift_R+F11
        # toggle_preset=Shift_R+F10
        # toggle_fps_limit=Shift_R+F1
        # toggle_logging=Shift_L+F2
        # reload_cfg=Shift_L+F4
        # upload_log=Shift_L+F3
        # reset_fps_metrics=Shift_R+f9
        toggle_hud = "Shift_R+F12";
        toggle_fps_limit = "Shift_R+F1";
      };
    };
  };
}
