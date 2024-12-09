{ config, pkgs, ... }:
{
  networking.hostName = "dhcp1";

  imports = [ ../base.nix ];

  environment.systemPackages = with pkgs; [
    rustc
    cargo
  ];

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
