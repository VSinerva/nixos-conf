{ config, pkgs, ... }:
{
  networking.hostName = "dhcp-cluster-node";

  imports = [ ../base.nix ];

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
