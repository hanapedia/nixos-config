{ config, pkgs, ... }: {
  networking = {
    interfaces.enp5s0.ipv4.addresses = [{
      address = "192.168.10.10";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.10.1";
    nameservers = [ "8.8.8.8" ];
  };

  # allow bgp port
  networking.firewall.allowedTCPPorts = [ 179 ];

  # bgp setup using BIRD
  services.bird2 = {
    enable = true;
    package = pkgs.bird3;
    config = ''
      log syslog all;
      router id 192.168.10.10;

      protocol kernel {
        persist;
        scan time 20;

        ipv4 {
          import all;
          export all;
        };
      }

      protocol device {
        scan time 10;
      }

      protocol static {
        ipv4;
        # Container subnet on this node
        route 10.1.0.0/24 via "br0";  # Replace "br0" with your actual container bridge
      }

      protocol bgp to_router {
        local as 65001;
        neighbor 192.168.10.1 as 65000;

        ipv4 {
          import all;
          export all;
        };
      }
    '';
  };
  # setup br0, which can be used for virtual network later by something like docker.
  networking.bridges.br0.interfaces = [ ]; # Empty if you're not bridging real NICs

  networking.interfaces.br0 = {
    ipv4.addresses = [{
      address = "10.1.0.1";
      prefixLength = 24;
    }];
    # Do not use DHCP here — you're statically assigning it
  };
}
