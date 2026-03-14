{
  config,
  pkgs,
  home-manager,
  username,
  flakeDir,
  ...
}: {
  environment.systemPackages = with pkgs; [zellij];

  home-manager.users.${username} = {config, ...}: {
    programs.zellij = {
      enable = true;
    };

    home.shellAliases = {
      ze = "zellij -l welcome";
    };

    home.file.".config/zellij/config.kdl" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/config/zellij/config.kdl";
    };
  };
}
