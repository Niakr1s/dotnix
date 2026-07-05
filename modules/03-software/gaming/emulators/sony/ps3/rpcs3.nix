{
  pkgs,
  username,
  flakeDir,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # rpcs3 TODO: uncomment htis after flake update, because it seems to be fixed
    (rpcs3.overrideAttrs (prev: {
      cmakeFlags = prev.cmakeFlags ++ [ (lib.cmakeBool "BUILD_SHARED_LIBS" false) ];
    }))
  ];

  home-manager.users.${username} = { config, ... }: {
    home.file.".config/rpcs3/config.yml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/rpcs3/config.yml";
      force = true;
    };
    home.file.".config/rpcs3/custom_configs" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/home/.config/rpcs3/custom_configs";
    };
  };
}
