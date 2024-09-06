{ config, pkgs, ... }:
{
  networking.hostName = "nixos";

  imports = [ ../base.nix ];

  #Many installs will need this, and it won't hurt either way
  services.qemuGuest.enable = true;

  #Prevent user from being locked out of the system before switching to proper config
  users.mutableUsers = pkgs.lib.mkForce true;
}
