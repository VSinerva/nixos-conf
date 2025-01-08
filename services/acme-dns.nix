{ ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "vili.m.sinerva@gmail.com";
      environmentFile = "/var/lib/acme/dns-creds";
      dnsProvider = "ovh";
      group = "nginx";
      extraLegoFlags = [
        "--dns.propagation-wait"
        "60s"
      ];
    };
  };
}
