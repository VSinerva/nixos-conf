{ config, ... }:
{
  users.users."cert-store" = {
    isNormalUser = true;
    description = "Read-only access to certs";
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys ++ [
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
        chown -R cert-store:cert-store ${config.users.users."cert-store".home}/acme/
        chmod ugoa=r ${config.users.users."cert-store".home}/acme/*.pem
      '';
    };
  };
}
