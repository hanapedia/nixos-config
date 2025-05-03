{ pkgs, ... }:
{
  users.users.hanapedia = {
    isNormalUser = true;
    description = "Hiroki";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
    shell = pkgs.bash;
  };

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "hanapedia";

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
