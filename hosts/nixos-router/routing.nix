{ config, pkgs, ... }: {
  # Configuration for router with
  # 1. no NAT capability
  # 2. subnet with DHCP for NICs enp2s0, enp3s0, enp4s0
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
  };
  networking = {
    interfaces = {
      enp1s0.useDHCP = true;  # Home router uplink

      enp2s0.ipv4.addresses = [{
        address = "192.168.10.1";
        prefixLength = 24;
      }];

      enp3s0.ipv4.addresses = [{
        address = "192.168.20.1";
        prefixLength = 24;
      }];

      enp4s0.ipv4.addresses = [{
        address = "192.168.30.1";
        prefixLength = 24;
      }];
    };

    # Optional: Set home router as default route
    defaultGateway = "192.168.1.1";
  };

  services.dnsmasq = {
    enable = true;

    settings = {
      # Interface-specific settings
      interface = [ "enp2s0" "enp3s0" "enp4s0" ];
      bind-interfaces = true;

      # Disable DNS if you're only using DHCP
      port = 53;

      # Prevent it from using /etc/resolv.conf
      no-resolv = true;

      # Explicit upstream resolvers
      server = [ "8.8.8.8" "1.1.1.1" ];

      # Subnet for enp2s0
      dhcp-range = [
        "enp2s0,192.168.10.100,192.168.10.200,255.255.255.0,24h"
        "enp3s0,192.168.20.100,192.168.20.200,255.255.255.0,24h"
        "enp4s0,192.168.30.100,192.168.30.200,255.255.255.0,24h"
      ];

      # Set the gateway (router) address for each subnet
      dhcp-option = [
        "enp2s0,3,192.168.10.1"
        "enp3s0,3,192.168.20.1"
        "enp4s0,3,192.168.30.1"
      ];
    };
  };
}
