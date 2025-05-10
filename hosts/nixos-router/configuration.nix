{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./routing.nix
    ../../modules/base.nix
    ../../modules/user.nix
    ../../modules/cli.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  services.openssh.enable = true;

  system.stateVersion = "25.05";
}
