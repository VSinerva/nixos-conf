{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [ 443 ];

  services.nextcloud = {
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
    };
  };

  services.nginx.virtualHosts = {
    ${config.services.nextcloud.hostName} = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/var/lib/nextcloud/nextcloud_fullchain.pem";
      sslCertificateKey = "/var/lib/nextcloud/nextcloud_privkey.pem";
      locations = {
        "/".proxyWebsockets = true;
        "~ ^\/nextcloud\/(?:index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|oc[ms]-provider\/.+|.+\/richdocumentscode\/proxy)\.php(?:$|\/)" =
          { };
      };
    };
  };
}
