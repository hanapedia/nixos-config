{ config, pkgs, ... }: {
  imports = [
    # ../modules/hardware-configuration.nix
    ../modules/base.nix
    ../modules/user.nix
    ../modules/cli.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  services.openssh.enable = true;

  system.stateVersion = "24.11";
}
