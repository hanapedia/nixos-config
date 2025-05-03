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

  environment.systemPackages = with pkgs; [
    fish
    fishPlugins.fzf-fish
    fishPlugins.bobthefish
    fzf
    tmux
    tailscale
    gcc
    ripgrep
  ];

  environment.variables.EDITOR = "neovim";
}
