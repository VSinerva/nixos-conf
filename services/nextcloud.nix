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
        sslCertificate = "/var/lib/nextcloud/fullchain.pem";
        sslCertificateKey = "/var/lib/nextcloud/privkey.pem";
      };
    };
  };
}
