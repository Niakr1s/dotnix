{
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../modules/editors/vscode.nix
    ../../modules/vm/virt-manager.nix

    # nvf ai mode
    ../../modules/editors/nvf/ai.nix

    ### Docker services
    ../../modules/docker/services/comfyui.nix
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
