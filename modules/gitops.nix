{
  virtualisation.podman.enable = true;
  virtualisation.oci-containers.backend = "podman";

  # Just ensure the state/config dir exists; you manage the YAML out-of-band.
  systemd.tmpfiles.rules = [
    "d /var/lib/nixos-gitops 0750 root root -"
  ];

  virtualisation.oci-containers.containers.nixos-gitopsd = {
    # 2) Pin by digest (example digest shown; replace with your own)
    image = "nixos-server-r596:5000/hanapedia/nixos-gitops:dev";

    autoStart = true;

    extraOptions = [
      # 2) Don’t attempt pulls at start; we’re pinned to a digest.
      "--tls-verify=false"
      "--pull=always"
      # Host access for nixos-rebuild to affect the host
      "--network=host"
      "--pid=host"
      "--privileged"
    ];

    volumes = [
      # 1) Mount your out-of-band config file into the container
      "/etc/nixos-gitops/config.yaml:/etc/nixos-gitops/config.yaml:ro"
      # agent state + repo workdir
      "/var/lib/nixos-gitops:/var/lib/nixos-gitops"
      # host nix + systemd so the agent can switch generations
      "/nix:/nix"
      "/run/current-system:/run/current-system:ro"
      "/run/systemd:/run/systemd"
    ];

    environment = {
      PATH = "/run/current-system/sw/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
    };

    cmd = [ "daemon" "--config" "/etc/nixos-gitops/config.yaml" ];

    # With digest pinning and --pull=never, auto-update is typically disabled.
    # (Omit the autoupdate label.)
    # labels = { };
  };

  # make the agent depend on the registry container
  systemd.services."podman-nixos-gitopsd".after = [ "podman-registry.service" "network-online.target" ];
  systemd.services."podman-nixos-gitopsd".requires = [ "podman-registry.service" ];
  systemd.services."podman-nixos-gitopsd".wants = [ "podman-registry.service" ];

  # Make the generated systemd unit resilient; rebuilds never block.
  systemd.services."podman-nixos-gitopsd".serviceConfig = {
    Restart = "always";
    RestartSec = 5;
    StartLimitIntervalSec = 0;
    TimeoutStartSec = 0;
  };
}
