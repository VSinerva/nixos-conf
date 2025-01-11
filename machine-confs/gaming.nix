{ pkgs, ... }:
{
  networking.hostName = "gaming";

  imports = [
    ../base.nix
    ../users/vili.nix
    ../desktop.nix
    ../gaming.nix
    ../services/sunshine.nix
    #    ../hardware-specific/nvidia.nix
  ];

  users.users.vili.hashedPasswordFile = pkgs.lib.mkForce null;

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
