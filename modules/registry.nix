{
  virtualisation.podman.enable = true;
  virtualisation.oci-containers.backend = "podman";

  systemd.tmpfiles.rules = [
    "d /srv/registry 0755 root root -"
  ];

  virtualisation.oci-containers.containers.registry = {
    image = "registry:2";
    autoStart = true;
    ports = [ "5000:5000" ];
    volumes = [
      "/srv/registry:/var/lib/registry"
      "/srv/registry/config.yaml:/etc/docker/registry/config.yaml:ro"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 5000 ];

  systemd.services."podman-registry".serviceConfig = {
    Restart = "always";
    RestartSec = 5;
    StartLimitIntervalSec = 0;
    TimeoutStartSec = 0;
  };
}
