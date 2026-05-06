{
  pkgs,
  username,
  ...
}: {
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # To force wayland
  };

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
