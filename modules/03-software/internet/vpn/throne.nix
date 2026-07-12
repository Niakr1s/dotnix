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
    (flakeLib.link ".config/Throne/config/route_profiles/Default")
  ];
}
