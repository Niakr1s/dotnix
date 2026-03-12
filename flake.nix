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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mysecrets = {
      url = "git+ssh://git@github.com/Niakr1s/secrets.git?ref=main&shallow=1";
      # url = "git@github.com:Niakr1s/secrets.git";
      flake = false;
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    sqlit = {
      url = "github:Maxteabag/sqlit";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    disko,
    sops-nix,
    nvf,
    sqlit,
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
    flakeDir = "/etc/nixos"; # root of this flake

    mkHostConfig = hostname: stateVersion: {
      ${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit hostname;
          inherit username;
          inherit flakeDir;
        };
        modules = [
          unstable-overlays

          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops

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
  in {
    nixpkgs.hostPlatform = "${system}";

    nixosConfigurations =
      (mkHostConfig "desktop" "25.11")
      // (mkHostConfig "laptop" "25.11");
  };
}
