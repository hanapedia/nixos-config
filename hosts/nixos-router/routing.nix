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

    # enable NAT so that home router can return packets from internet
    nat = {
      enable = true;
      internalInterfaces = [ "enp2s0" "enp3s0" "enp4s0" ];
      externalInterface = "enp1s0";
    };
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

  # bgp setup using BIRD
  environment.systemPackages = [ pkgs.bird3 ];
  services.bird = {
    enable = true;
    package = pkgs.bird3;
    config = ''
      log syslog all;
      router id 192.168.1.200;

      protocol kernel {
        persist;
        scan time 20;
        import all;
        export all;
      }

      protocol device {
        scan time 10;
      }

      # Peer with nixos-server-r555
      protocol bgp r555 {
        local as 65000;
        neighbor 192.168.10.10 as 65001;

        import all;
        export all;
      }

      # Peer with nixos-server-r514
      protocol bgp r514 {
        local as 65000;
        neighbor 192.168.20.10 as 65002;

        import all;
        export all;
      }
    '';
  };
}
