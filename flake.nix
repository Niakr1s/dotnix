{
  description = "Declarating... Imperative machines...";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvidia-pstated = {
      url = "github:sasha0552/nvidia-pstated";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comfyui = {
      url = "github:utensils/comfyui-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://cache.nixos-cuda.org"
      "https://nix-community.cachix.org"
      "https://comfyui.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "comfyui.cachix.org-1:33mf9VzoIjzVbp0zwj+fT51HG0y31ZTK3nzYZAX0rec="
    ];
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      hjem,
      nvidia-pstated,
      dms-plugin-registry,
      comfyui,
      ...
    }:
    let
      stVersion = "26.05";
      hostNames = builtins.attrNames (
        nixpkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./hosts)
      );
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hostNames (
        hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            flakeLib = nixpkgs.legacyPackages.${system}.callPackage ./flakeLib.nix { };
            inherit hostname;
          };
          modules = [
            inputs.hjem.nixosModules.default
            inputs.nvidia-pstated.nixosModules.default
            inputs.comfyui.nixosModules.default
            inputs.dms-plugin-registry.nixosModules.default
            ./config.nix
            ./modules
            ./hosts/${hostname}

            # aliases
            (
              { lib, config, ... }:
              let
                user = config.modules.core.user;
              in
              {
                imports = [
                  (lib.mkAliasOptionModule [ "home" ] [ "hjem" "users" "${user}" "files" ])
                ];
              }
            )

            # overlays
            ({ config, ... }: {
              nixpkgs.overlays = [
                (final: prev: {
                  unstable = import nixpkgs-unstable {
                    inherit system;
                    config = {
                      allowUnfree = true;
                      cudaSupport = config.modules.core.gpu.nvidia.enable;
                    };
                  };
                })
                comfyui.overlays.default
              ];
            })

            # base config
            (
              { config, ... }:
              let
                user = config.modules.core.user;
              in
              {
                config = {
                  networking.hostName = hostname;
                  system.stateVersion = stVersion;
                  nixpkgs.config.cudaSupport = config.modules.core.gpu.nvidia.enable;
                  hjem.users.${user} = {
                    enable = true;
                    clobberFiles = true;
                  };
                };
              }
            )
          ];
        }
      );

      # Devshell
      devShells.${system} = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            python314
            ruff
          ];
        };
      };
    };
}
