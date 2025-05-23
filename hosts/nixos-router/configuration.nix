{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./routing.nix
    ../../modules/base.nix
    ../../modules/user.nix
    ../../modules/cli.nix
    ../../modules/security.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  system.stateVersion = "24.11";
}
