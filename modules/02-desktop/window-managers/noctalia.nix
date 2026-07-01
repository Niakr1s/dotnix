# This module is supposed to be used alongside with wayland compositors
# like niri, mango, hyprland
# It handles lock using swayidle

{
  pkgs,
  username,
  flakeDir,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    wlopm
    noctalia-shell
    swayidle
  ];

  security.pam.services.gtklock = { };

  # example command
  # gtklock -b \"$(jq -r 'first(.wallpapers[].dark) // .defaultWallpaper' ~/.cache/noctalia/wallpapers.json)\" -f

  programs.gtklock = {
    enable = true;
    modules = with pkgs; [
      gtklock-virtkb-module
    ];
  };

  home-manager.users.${username} =
    { config, ... }:
    {
      # services.swayidle =
      #   let
      #     lock = "${pkgs.noctalia-shell}/bin/noctalia-shell ipc call sessionMenu lockAndSuspend";
      #     display = status: "${pkgs.wlopm}/bin/wlopm --${status} '*'";
      #     lockTimeout = if hostname == "laptop" then 300 else 600;
      #     displayOffTimeout = 20;
      #   in
      #   {
      #     enable = true;
      #     timeouts = [
      #       # lock and suspend
      #       {
      #         timeout = lockTimeout;
      #         command = lock;
      #         resumeCommand = display "on";
      #       }
      #
      #       # turn off display after lock (for hosts where suspend disabled)
      #       {
      #         timeout = lockTimeout + displayOffTimeout;
      #         command = display "off";
      #         resumeCommand = display "on";
      #       }
      #
      #       # turn off display while idle on lockscreen
      #       {
      #         timeout = displayOffTimeout;
      #         command = "${pkgs.procps}/bin/pgrep gtklock && { ${lock}; ${display "off"}; }; }";
      #         resumeCommand = display "on";
      #       }
      #     ];
      #   };

      home.file.".config/noctalia" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/noctalia";
      };

    };
}
