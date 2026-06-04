{ pkgs, lib, ... }: {
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    kind
    kubectl
    kustomize
  ];

  users.users.hanapedia.extraGroups = [ "docker" ];
}
