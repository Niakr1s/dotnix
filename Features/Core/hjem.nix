{
  config,
  lib,
  ...
}:
let
  user = config.core.user;
  git = config.core.git;
in
{
  hjem.users.${user} = {
    enable = true;
    files.".gitconfig".text = ''
      [user]
      name = ${git.user}
      email = ${git.email}
    '';
  };
}
