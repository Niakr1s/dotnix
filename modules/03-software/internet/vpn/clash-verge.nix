{
  ...
}:
{
  programs.clash-verge = {
    enable = true;
    autoStart = true;
    group = "wheel"; # The group to grant access to clash-verge-rev's service socket
    serviceMode = true;
    tunMode = true;
  };
}
