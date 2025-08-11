{ pkgs, ... }: {
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  programs.git.enable = true;
  programs.fish.enable = true;

  programs.bash.interactiveShellInit = ''
    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    fi
  '';

  programs.tmux.enable = true;

  # alphabetical order
  environment.systemPackages = with pkgs; [
    bat
    bcc
    bear
    bpftools
    bpftrace
    clang 
    fish
    fishPlugins.bobthefish
    fishPlugins.fzf-fish
    fzf
    gcc
    ghostty
    ghq
    gnumake
    libbpf
    llvm
    openssl
    ripgrep
    tailscale
    tcpdump
    tmux
    unzip
  ];

  environment.variables.EDITOR = "neovim";
}
