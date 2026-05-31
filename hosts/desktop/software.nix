{
  pkgs,
  username,
  ...
}: {
  imports = [
    # ../../modules/editors/vscode.nix
    # ../../modules/editors/zed.nix
    ../../modules/vm/virt-manager.nix

    ### Docker services
    ../../modules/docker/services/comfyui.nix
    ../../modules/docker/services/flibusta.nix
  ];
}
