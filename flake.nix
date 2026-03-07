{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    disko,
    nvf,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    unstable-overlays = {
      nixpkgs.overlays = [
        (final: prev: {
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        })
      ];
    };

    username = "nea"; # will be common among my hosts

    mkHostConfig = hostname: stateVersion: {
      ${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit hostname;
          inherit username;
        };
        modules = [
          unstable-overlays

          disko.nixosModules.disko
          home-manager.nixosModules.home-manager

          # Configurations
          ./hosts/${hostname}/configuration.nix # probably we can hardcode this
          {
            system.stateVersion = "${stateVersion}"; # Set this to first installed version, and then don't change it
            nixpkgs.config.allowUnfree = true;
            nix.settings.experimental-features = ["nix-command" "flakes"];
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit hostname;
              inherit username;
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
  in {
    nixpkgs.hostPlatform = "${system}";

    nixosConfigurations =
      (mkHostConfig "desktop" "25.11")
      // (mkHostConfig "laptop" "25.11");
  };
}
