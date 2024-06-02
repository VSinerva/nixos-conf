{ config, pkgs, ... }:
{
  networking.hostName = "nixos-cpu";

  imports = [
    ../base.nix
    ../development.nix
    ../vili.nix
    ../syncthing.nix
  ];

# HARDWARE SPECIFIC

services.qemuGuest.enable = true;

boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

}
