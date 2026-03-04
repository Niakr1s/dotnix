{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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

    desktopStateVersion = "25.11"; # version of iso
    desktopHostName = "desktop"; # desktop hostname
  in {
    # desktop configuration
    nixosConfigurations.${desktopHostName} = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        stateVersion = "${desktopStateVersion}";

        hostname = "${desktopHostName}";
        inherit username;
      };
      modules = [
        ./configuration.nix

        unstable-overlays

        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = {
            inherit inputs;
            stateVersion = "${desktopStateVersion}";

            hostname = "${desktopHostName}";
            inherit username;
          };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nea = import ./home.nix;
        }
      ];
    };
  };
}
