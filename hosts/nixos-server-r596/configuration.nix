{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/gc.nix
    # ./routing.nix
    ../../modules/base.nix
    ../../modules/desktop.nix
    ../../modules/user.nix
    ../../modules/cli.nix
    ../../modules/gui.nix
    ../../modules/radeon.nix
    ../../modules/gaming.nix
    ../../modules/security.nix
    ../../modules/languages.nix
    ../../modules/virtualization.nix
    /* ../../modules/registry.nix */
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  system.stateVersion = "25.11";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # allow privates address
  networking.firewall.extraCommands = ''
    iptables -I FORWARD -s 10.0.0.0/8 -j ACCEPT
    iptables -I FORWARD -d 10.0.0.0/8 -j ACCEPT
    iptables -I FORWARD -s 172.16.0.0/12 -j ACCEPT
    iptables -I FORWARD -d 172.16.0.0/12 -j ACCEPT
    iptables -I FORWARD -s 192.168.0.0/16 -j ACCEPT
    iptables -I FORWARD -d 192.168.0.0/16 -j ACCEPT
  '';
  networking.firewall.extraStopCommands = ''
    iptables -D FORWARD -s 10.0.0.0/8 -j ACCEPT || true
    iptables -D FORWARD -d 10.0.0.0/8 -j ACCEPT || true
    iptables -D FORWARD -s 172.16.0.0/12 -j ACCEPT || true
    iptables -D FORWARD -d 172.16.0.0/12 -j ACCEPT || true
    iptables -D FORWARD -s 192.168.0.0/16 -j ACCEPT || true
    iptables -D FORWARD -d 192.168.0.0/16 -j ACCEPT || true
  '';
  # disable rp_filter
  boot.kernel.sysctl."net.ipv4.conf.default.rp_filter" = 0;
}
