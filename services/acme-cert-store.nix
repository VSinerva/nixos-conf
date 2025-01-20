{ config, ... }:
{
  users.users."cert-store" = {
    isNormalUser = true;
    description = "Read-only access to certs";
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys ++ [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHj2PK6LHsanSqaz8Gf/VqHaurd5e6Y7KnZNBiHb9adT nextcloud"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDiJZWlmiEkVzlf5/KV/jKkCGlgp8mnEeCnwk/dhdctJ gitea"
    ];
  };

  security.acme = {
    acceptTerms = true;
    certs."vsinerva.fi".extraDomainNames = [ "*.vsinerva.fi" ];
    defaults = {
      email = "vili.m.sinerva@gmail.com";
      environmentFile = "/var/lib/acme/dns-creds";
      dnsProvider = "ovh";
      extraLegoFlags = [
        "--dns.propagation-wait"
        "60s"
      ];
      postRun = ''
        mkdir -p ${config.users.users."cert-store".home}/acme
        cp fullchain.pem ${config.users.users."cert-store".home}/acme/
        cp key.pem ${config.users.users."cert-store".home}/acme/
        chmod o+r ${config.users.users."cert-store".home}/acme/*.pem
      '';
    };
  };
}
