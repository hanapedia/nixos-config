{
  description = "eBPF dev env";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  outputs = { self, nixpkgs, ... }:
  let
    for = system: let pkgs = import nixpkgs { inherit system; }; in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          bear
          bpftools
          bpftrace
          clang-tools
          gnumake
          libbpf
          llvmPackages_18.clang-unwrapped
          llvmPackages_18.bintools
          pkg-config
        ];
        shellHook = ''
          export CC=clang
          export AR=llvm-ar
          export NM=llvm-nm
          export RANLIB=llvm-ranlib
        '';
      };
    };
  in {
    # per-arch outputs
    devShells.x86_64-linux = (for "x86_64-linux").devShells;
    devShells.aarch64-linux = (for "aarch64-linux").devShells;
  };
}
