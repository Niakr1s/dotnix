{
  pkgs,
  inputs,
  system,
  ...
}: {
  # enables binary cache
  nix.settings = {
    trusted-substituters = ["https://ai.cachix.org"];
    trusted-public-keys = ["ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="];
  };

  services.comfyui = {
    enable = true;
    package = inputs.nixified-ai.packages.${system}.comfyui-nvidia;
    host = "0.0.0.0";
    # models = builtins.attrValues pkgs.nixified-ai.models;
    models = with pkgs.nixified-ai.models; [
      flux1-dev-q4_0
      flux-ae
      flux-text-encoder-1
      t5-v1_1-xxl-encoder

      # or define your own fetches discretely
      # (pkgs.fetchResource {
      #   name = "ultrarealistic.safetensors";
      #   url = "https://civitai.com/api/download/models/1026423?type=Model&format=SafeTensor";
      #   sha256 = "B1C4DDF95671E6B51817B4F3802865E544040C232C467E76B1CB0C251BD6B634";
      #   passthru = {
      #     comfyui.installPaths = ["loras"];
      #   };
      # })
    ];
    customNodes = with pkgs.comfyuiPackages; [
      comfyui-gguf
      # comfyui-impact-pack # sam2 error
    ];
  };
}
