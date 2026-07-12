{
  pkgs,
  flakeLib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # rpcs3 TODO: uncomment htis after flake update, because it seems to be fixed
    (rpcs3.overrideAttrs (prev: {
      cmakeFlags = prev.cmakeFlags ++ [ (lib.cmakeBool "BUILD_SHARED_LIBS" false) ];
    }))
  ];

  imports = [
    (flakeLib.mkHomeLink { homePath = ".config/rpcs3/config.yml"; })
    (flakeLib.mkHomeLink { homePath = ".config/rpcs3/custom_configs"; })
  ];
}
