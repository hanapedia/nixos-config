{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    go
    /* zig */
    /* zls */
    llvm
    lldb
    llvmPackages.clang-unwrapped
    bear
    bpftools
    bpftrace
    clang-tools
    gnumake
    libbpf
    pkg-config

  ];
}
