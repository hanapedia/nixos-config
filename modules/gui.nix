{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wl-clipboard
    obsidian
  ];

  programs.firefox.enable = true;

  environment.variables.EDITOR = "neovim";
}
