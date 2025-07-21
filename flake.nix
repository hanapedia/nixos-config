{
  description = "NixOS configuration with nixos-server and nixos-router";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, ... }: {
    nixosConfigurations = {
      nixos-server-r596 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-server-r596/configuration.nix
          { networking.hostName = "nixos-server-r596"; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hanapedia = ./hosts/nixos-server-r596/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
      
      nixos-server-r555 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-server-r555/configuration.nix
          { networking.hostName = "nixos-server-r555"; }
        ];
      };

      nixos-server-r514 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-server-r514/configuration.nix
          { networking.hostName = "nixos-server-r514"; }
        ];
      };

      nixos-router = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-router/configuration.nix
          { networking.hostName = "nixos-router"; }
        ];
      };
    };
  };
}
