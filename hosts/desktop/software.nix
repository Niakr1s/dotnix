{
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../modules/editors/vscode.nix
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    kdePackages.kdenlive
  ];

  # Home packages
  home-manager.users.${username} = {
    home.packages = with pkgs; [
    ];
  };
}
