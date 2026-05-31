{
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username} = {
    programs.vscode = {
      enable = true;

      # Extensions
      profiles.default.extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
      ];
    };
  };
}
