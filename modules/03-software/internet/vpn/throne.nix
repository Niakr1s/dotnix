{
  flakeLib,
  ...
}:
{
  programs.throne = {
    enable = true;
    tunMode = {
      enable = true;
    };
  };

  imports = [
    (flakeLib.mkHomeLink { homePath = ".config/Throne/config/route_profiles/Default"; })
  ];
}
