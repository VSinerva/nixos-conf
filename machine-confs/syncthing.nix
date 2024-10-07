{ config, pkgs, ... }:
{
  networking.hostName = "syncthing";

  imports = [
    ../base.nix
    ../users/vili.nix
    ../services/syncthing.nix
  ];

  users.users.vili.hashedPasswordFile = pkgs.lib.mkForce null;

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
