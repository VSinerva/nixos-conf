{ ... }:
{
  networking.hostName = "nat64";

  imports = [
    ../base.nix
    #    ../services/nat64.nix
  ];

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
