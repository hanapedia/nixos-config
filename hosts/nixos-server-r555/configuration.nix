{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ../../modules/base.nix
    ../../modules/desktop.nix
    ../../modules/user.nix
    ../../modules/cli.nix
    ../../modules/gui.nix
    ../../modules/security.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  services.openssh.enable = true;

  system.stateVersion = "24.11";
}
