{ config, pkgs, ... }:
{
  imports = [ ./cert-store-client.nix ];

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
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;

      virtualHosts.${config.services.nextcloud.hostName} = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = "/mnt/acme/fullchain.pem";
        sslCertificateKey = "/mnt/acme/key.pem";
      };
    };
  };
}
