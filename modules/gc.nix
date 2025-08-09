{
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";
  boot.loader.systemd-boot.configurationLimit = 5;
}
