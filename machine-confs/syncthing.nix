{ config, pkgs, ... }:
{
  networking.hostName = "syncthing";

  imports = [
    ../base.nix
    ../users/vili.nix
    ../services/syncthing.nix
  ];

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
