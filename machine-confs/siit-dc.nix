{ ... }:
{
  networking.hostName = "siit-dc";

  imports = [
    ../base.nix
    ../services/siit-dc.nix
  ];

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
