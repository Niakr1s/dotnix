{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mysecrets = {
      url = "git+ssh://git@github.com/Niakr1s/secrets.git?ref=main&shallow=1";
      # url = "git@github.com:Niakr1s/secrets.git";
      flake = false;
    };

    cia-unix = {
      url = "github:Niakr1s/cia-unix-full";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      disko,
      sops-nix,
      nur,
      dms-plugin-registry,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      username = "nea"; # will be common among my hosts
      flakeDir = "/etc/nixos"; # root of this flake

      mkHostConfig = hostname: stateVersion: {
        ${hostname} = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit self;
            inherit system;
            inherit inputs;
            inherit hostname;
            inherit username;
            inherit flakeDir;
            inherit nur;
            flakeLib = nixpkgs.legacyPackages.${system}.callPackage ./flakeLib.nix { };
          };
          modules = [
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            dms-plugin-registry.nixosModules.default

            # overlays
            {
              nixpkgs.overlays = [
                # pkgs.unstable
                (final: prev: {
                  unstable = import nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                  };
                })
                # pkgs.nur
                nur.overlays.default
              ];
            }

            # Configurations
            ./hosts/${hostname}/configuration.nix # probably we can hardcode this
            {
              system.stateVersion = "${stateVersion}"; # Set this to first installed version, and then don't change it
              nixpkgs.config.allowUnfree = true;
              nix.settings.experimental-features = [
                "nix-command"
                "flakes"
              ];
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit hostname;
                inherit username;
                inherit flakeDir;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = {
                home.stateVersion = "${stateVersion}"; # Set this to first installed version, and then don't change it
                home.username = "${username}";
                home.homeDirectory = "/home/${username}";
              };
            }
          ];
        };
      };
    in
    {
      nixpkgs.hostPlatform = "${system}";

      nixosConfigurations = (mkHostConfig "desktop" "25.11") // (mkHostConfig "laptop" "25.11");
    };
}
