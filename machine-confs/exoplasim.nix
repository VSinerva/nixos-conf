{ config, pkgs, ... }:
{
  networking.hostName = "exoplasim";

  imports = [ ../base.nix ];

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
