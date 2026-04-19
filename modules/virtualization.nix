{ pkgs, lib, ... }: {
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    kind
    kubectl
  ];

  users.users.hanapedia.extraGroups = [ "docker" ];
}
