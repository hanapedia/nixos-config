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

  system.stateVersion = "26.05";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # allow privates address
  networking.firewall = {
    enable = true;
    trustedInterfaces = ["docker0" "br-+"];
    checkReversePath = false;
    # extraCommands = ''
    #   iptables -I FORWARD -s 10.0.0.0/8 -j ACCEPT
    #   iptables -I FORWARD -d 10.0.0.0/8 -j ACCEPT
    #   iptables -I FORWARD -s 172.16.0.0/12 -j ACCEPT
    #   iptables -I FORWARD -d 172.16.0.0/12 -j ACCEPT
    #   iptables -I FORWARD -s 192.168.0.0/16 -j ACCEPT
    #   iptables -I FORWARD -d 192.168.0.0/16 -j ACCEPT
    # '';
    # extraStopCommands = ''
    #   iptables -D FORWARD -s 10.0.0.0/8 -j ACCEPT || true
    #   iptables -D FORWARD -d 10.0.0.0/8 -j ACCEPT || true
    #   iptables -D FORWARD -s 172.16.0.0/12 -j ACCEPT || true
    #   iptables -D FORWARD -d 172.16.0.0/12 -j ACCEPT || true
    #   iptables -D FORWARD -s 192.168.0.0/16 -j ACCEPT || true
    #   iptables -D FORWARD -d 192.168.0.0/16 -j ACCEPT || true
    # '';
  };
  # disable rp_filter
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.bridge.bridge-nf-call-iptables" = 1;
  };
  boot.kernelModules = ["br_netfilter" "fou"];

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/121fce1a-0da9-42d3-9ea5-d84d62ab79fc";
    fsType = "ext4";
  };
  # allow running pre built bins
  programs.nix-ld.enable = true;
  # allow edits to /etc/hosts
  environment.etc."hosts".mode = "0644";

  systemd.tmpfiles.rules = [
    "L+ /lib/modules - - - - /run/booted-system/kernel-modules/lib/modules"
  ];
}
