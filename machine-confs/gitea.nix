{ ... }:
{
  networking.hostName = "gitea";

  imports = [
    ../base.nix
    ../services/gitea.nix
  ];

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
