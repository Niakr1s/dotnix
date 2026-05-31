{
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username} = {
    home.packages = [pkgs.tealdeer];
    services.tldr-update = {
      enable = true;
      package = pkgs.tealdeer;
      period = "weekly";
    };
  };
}
