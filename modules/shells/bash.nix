{username, ...}: {
  home-manager.users.${username} = {
    programs.bash = {
      enable = true;
      bashrcExtra = ''
        set -o vi
      '';
    };
  };
}
