{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [ 443 ];

  services = {
    nextcloud = {
      package = pkgs.nextcloud30;
      enable = true;
      hostName = "nextcloud.vsinerva.fi";
      autoUpdateApps.enable = true;
      https = true;
      maxUploadSize = "10G";
      config = {
        adminpassFile = "/var/lib/nextcloud/adminpass";
      };
      settings = {
        overwriteprotocol = "https";
        maintenancce_window_start = 1;
        opcache.interned_strings_buffer = 32;
      };
    };

    nginx = {
      recommendedGzipSettings = true;

      virtualHosts.${config.services.nextcloud.hostName} = {
        forceSSL = true;
        kTLS = true;
        enableACME = true;
        acmeRoot = null;
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "vili.m.sinerva@gmail.com";
      environmentFile = "/var/lib/nextcloud/dns-creds";
      dnsProvider = "ovh";
      group = "nginx";
      server = "https://acme-staging-v02.api.letsencrypt.org/directory";
    };
  };
}
