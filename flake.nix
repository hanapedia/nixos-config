{
  description = "NixOS configuration with nixos-server and nixos-router";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: {
    nixosConfigurations = {
      nixos-server-r596 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-server-r596/configuration.nix
          { networking.hostName = "nixos-server-r596"; }
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
