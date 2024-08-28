{ config, pkgs, ... }:
{
  networking.hostName = "nixos";

  imports = [ ../base.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #Many installs will need this, and it won't hurt either way
  services.qemuGuest.enable = true;
}
