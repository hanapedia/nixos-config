{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wl-clipboard
    ghostty
    google-chrome
  ];

  environment.variables.EDITOR = "neovim";
}
