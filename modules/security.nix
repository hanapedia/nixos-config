{ pkgs, ... }:
{
  security.sudo.wheelNeedsPassword = false;

  users.users.hanapedia.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAgVSabBfACDa4CqEVCgTS2VCEfvpURhUwxhgU3woKJc hiroki11hanada@gmail.com"
  ];
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "prohibit-password";
  };
}
