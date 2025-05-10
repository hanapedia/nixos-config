{
  networking = {
    interfaces.enp35s0.ipv4.addresses = [{
      address = "192.168.20.10";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.20.1";
    nameservers = [ "8.8.8.8" ];
  };
}
