{ config, pkgs, ... }:
{
  networking.hostName = "nixos";

  imports = [ ../base.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #Many installs will need this, and it won't hurt either way
  services.qemuGuest.enable = true;

  #Prevent user from being locked out of the system before switching to proper config
  users.mutableUsers = pkgs.lib.mkForce true;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];
}
