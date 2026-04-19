{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    go
    /* zig */
    /* zls */
    llvm
    lldb
    clang
    bear
    bpftools
    bpftrace
    clang-tools
    gnumake
    libbpf
    /* llvmPackages_18.clang-unwrapped */
    /* llvmPackages_18.bintools */
    pkg-config

  ];
}
