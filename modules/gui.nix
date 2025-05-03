{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wl-clipboard
    ghostty
    google-chrome
  ];

  programs.firefox.enable = true;

  environment.variables.EDITOR = "neovim";
}
