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
    (flakeLib.mkHomeLink ".config/Throne/config/route_profiles/Default")
  ];
}
