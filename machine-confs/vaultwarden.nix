{ ... }:
{
  networking.hostName = "vaultwarden";

  imports = [
    ../base.nix
    ../services/vaultwarden.nix
  ];

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
