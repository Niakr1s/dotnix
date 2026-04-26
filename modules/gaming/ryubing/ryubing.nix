{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  hostname,
  username,
  home-manager,
  flakeDir,
  ...
}: let
  prodKeysFile = "prod.v21.2.0.keys";

  # Read the contents of the original desktop file provided by the package
  originalDesktopFile = builtins.readFile "${pkgs.ryubing}/share/applications/Ryujinx.desktop";
  # Create a modified version with the new Exec line
  modifiedDesktopFile = pkgs.runCommand "modified-ryujinx-desktop" {} ''
    echo "${originalDesktopFile}" > $out
    sed -i 's|^Exec=\(.*\)|Exec=gnome-session-inhibit --reason=Ryujinx --app-id=ryujinx \1|' $out
  '';
in {
  environment.systemPackages = with pkgs; [
    ryubing
    nsz
  ];

  home-manager.users.${username} = {config, ...}: {
    home.file.".local/share/applications/Ryujinx.desktop" = {
      text = builtins.readFile modifiedDesktopFile;
      force = true;
    };

    # for nsz
    home.file.".switch/prod.keys" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/Ryujinx/system/${prodKeysFile}";
    };

    home.file.".config/Ryujinx/system/prod.keys" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/Ryujinx/system/${prodKeysFile}";
    };
    home.file.".config/Ryujinx/Config.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/Ryujinx/Config.json";
    };
  };
}
