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
  };

  nixConfig = {
    trusted-substituters = [
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      hjem,
      nvidia-pstated,
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
            ./config.nix
            ./modules
            ./hosts/${hostname}

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
