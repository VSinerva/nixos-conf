{ config, pkgs, ... }:
{
  networking.hostName = "ntfy";

  imports = [
    ../base.nix
    ../services/ntfy.nix
  ];

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
