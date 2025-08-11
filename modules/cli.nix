{ pkgs, ... }: {
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  programs.git.enable = true;
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.shells = [ pkgs.fish pkgs.bashInteractive ];

  programs.tmux.enable = true;

  # alphabetical order
  environment.systemPackages = with pkgs; [
    bat
    bpftools
    bpftrace
    fish
    fishPlugins.bobthefish
    fishPlugins.fzf-fish
    fzf
    ghostty
    ghq
    gnumake
    openssl
    ripgrep
    tailscale
    tcpdump
    tmux
    unzip
  ];

  environment.variables.EDITOR = "neovim";
}
