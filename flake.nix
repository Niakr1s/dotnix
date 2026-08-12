{
  description = "Declarating... Imperative machines...";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvidia-pstated = {
      url = "github:sasha0552/nvidia-pstated";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        nixpkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./Hosts)
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
          };
          modules = [
            inputs.hjem.nixosModules.default
            inputs.nvidia-pstated.nixosModules.default
            ./Hosts/${hostname}
            (
              {
                lib,
                config,
                ...
              }:
              let
                user = config.core.user;
              in
              {
                options.core = {
                  host = lib.mkOption {
                    type = lib.types.str;
                    description = "Hostname option explicity";
                    default = "${hostname}";
                    readOnly = true;
                  };
                };

                config = {
                  networking.hostName = hostname;
                  system.stateVersion = stVersion;
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
