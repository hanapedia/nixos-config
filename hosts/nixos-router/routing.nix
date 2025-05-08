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

  services.isc-dhcp-server = {
    enable = true;
    interfaces = [ "enp2s0" "enp3s0" "enp4s0" ];
    sharedNetworks = {
      "192-168-10" = {
        subnet = "192.168.10.0";
        netmask = "255.255.255.0";
        range = [ "192.168.10.2" "192.168.10.255" ];
        routers = [ "192.168.10.1" ];
      };
      "192-168-20" = {
        subnet = "192.168.20.0";
        netmask = "255.255.255.0";
        range = [ "192.168.20.2" "192.168.20.255" ];
        routers = [ "192.168.20.1" ];
      };
      "192-168-30" = {
        subnet = "192.168.30.0";
        netmask = "255.255.255.0";
        range = [ "192.168.30.2" "192.168.30.255" ];
        routers = [ "192.168.30.1" ];
      };
    };
  };
}
