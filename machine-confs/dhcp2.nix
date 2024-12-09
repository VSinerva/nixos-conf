{ config, pkgs, ... }:
{
  networking.hostName = pkgs.lib.mkForce "dhcp2";

  imports = [
    ../base.nix
    ./dhcp1.nix
  ];
}
