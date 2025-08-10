{ pkgs, lib, ... }: {
  virtualisation.podman.enable = true;

  environment.systemPackages = with pkgs; [
    podman
  ];

  virtualisation.containers.registries.insecure = [ "nixos-server-r596:5000" ];

  environment.etc."containers/registries.conf".text = lib.mkForce ''
    unqualified-search-registries = ["docker.io"]

    [[registry]]
    prefix = "docker.io"
    location = "docker.io"
      [[registry.mirror]]
      location = "nixos-server-r596:5000"
      insecure = true
  '';
}
