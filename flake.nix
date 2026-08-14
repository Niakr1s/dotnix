{
  description = "Declarating... Imperative machines...";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

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
            (
              {
                config,
                ...
              }:
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
