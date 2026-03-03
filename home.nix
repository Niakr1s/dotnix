{ config, lib, pkgs, nixpkgs-unstable, ... }:
let
  unstablePkgs = import nixpkgs-unstable {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };
in

{
  home.username = "nea";
  home.homeDirectory = "/home/nea";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
  ];

  programs.zsh = {
    enable = true;

    shellAliases = {
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Niakr1s";
        email = "pavel2188@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/nea/.dotnix/config/nvim";
    recursive = true;
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        accent-color = "blue";
	color-scheme = "prefer-dark";
      };

      "org/gnome/shell" = {
        favorite-apps = [
	  "firefox.desktop"
	  "org.gnome.Terminal.desktop"
	];
      };

      "org/gnome/shell/keybindings" = {
        toggle-message-tray = [];
	focus-active-notification = [];
	toggle-quick-settings = [];
	restore-shortcuts = [];
	toggle-application-view = ["<Super>d"];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        help = [];
	logout = [];
        screenreader = [];
	magnifier = [];
	magnifier-zoom-in = [];
	magnifier-zoom-out = [];
	screensaver = ["<Alt><Super>l"];
      };

      "org/gnome/mutter/keybindings" = {
        toggle-tiled-left = ["<Shift><Super>h"];
        toggle-tiled-right = ["<Shift><Super>l"];
      };

      "org/gnome/desktop/wm/keybindings" = {
	close = ["<Super>q"];
	minimize = [];
	maximize = [];
	unmaximize = [];
	begin-move = [];
	begin-resize = [];
	toggle-fullscreen = ["<Super>f"];
	toggle-maximized = ["<Shift><Super>f"];
	panel-run-dialog = ["<Alt><Super>d"];

        # Move to monitors
	move-to-monitor-down = [];
	move-to-monitor-up = [];
	move-to-monitor-left = ["<Shift><Super>bracketleft"];
	move-to-monitor-right = ["<Shift><Super>bracketright"];

        # Move to workspaces
	move-to-workspace-left = [];
	move-to-workspace-right = [];
	move-to-workspace-last = [];
	move-to-workspace-1 = ["<Shift><Super>1"];
	move-to-workspace-2 = ["<Shift><Super>2"];
	move-to-workspace-3 = ["<Shift><Super>3"];
	move-to-workspace-4 = ["<Shift><Super>4"];

	# Switch applications
	switch-applications = [];
	switch-applications-backward = [];

	# Switch system controls
	switch-panels = [];
	switch-panels-backward = [];

	# Switch system controls directly
	cycle-panels = [];
	cycle-panels-backward = [];

        # Switch to workspaces
	switch-to-workspace-1 = ["<Super>1"];
	switch-to-workspace-2 = ["<Super>2"];
	switch-to-workspace-3 = ["<Super>3"];
	switch-to-workspace-4 = ["<Super>4"];
	switch-to-workspace-last = [];
	switch-to-workspace-left = [];
	switch-to-workspace-right = [];

        # Switch windows
	switch-windows = [];
        switch-windows-backward = [];

	# Switch windows directly
	cycle-windows = ["<Super>Tab"];
        cycle-windows-backward = ["<Shift><Super>Tab"];

	# Switch windows of an app directly
	cycle-group = [];
	cycle-group-backward = [];

	# Switch windows of an application
	switch-group = [];
	switch-group-backward = [];
      };

      "org/gnome/shell" = {
        last-selected-power-profile = "perfomance";
        disable-user-extensions = false; # Optionally disable user extensions entirely
        enabled-extensions = [
          pkgs.gnomeExtensions.blur-my-shell.extensionUuid
          pkgs.gnomeExtensions.just-perfection.extensionUuid
	];
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-schedule-from = 20.0;
        night-light-schedule-to = 7.0;
	night-light-temperature = 3700;
      };

      # Configure individual extensions
      "org/gnome/shell/extensions/blur-my-shell" = {
        brightness = 0.75;
        noise-amount = 0;
      };

      "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
        font = "JetBrainsMono Nerd Font 10";
	use-system-font = false;
      };
    };
  };
}
