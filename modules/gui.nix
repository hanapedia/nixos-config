{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wl-clipboard
    ghostty
    obsidian
    lact
  ];

  programs.firefox.enable = true;

  environment.variables.EDITOR = "neovim";
}
