{ config, pkgs, ... }:
{
  networking.hostName = "nixos-cpu";

  imports = [
    ../base.nix
    ../users/vili.nix
    ../services/syncthing.nix
  ];

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
