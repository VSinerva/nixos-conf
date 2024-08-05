{ config, pkgs, ... }:
{
  networking.hostName = "nixos";

  imports = [ ../base.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
