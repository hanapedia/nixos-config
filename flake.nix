{
  description = "NixOS configuration with nixos-server and nixos-router";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: {
    nixosConfigurations = {
      nixos-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-server/configuration.nix
          { networking.hostName = "nixos-server"; }
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
