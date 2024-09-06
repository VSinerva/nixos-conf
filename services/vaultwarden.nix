{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [ 443 ];

  services = {
    vaultwarden = {
      enable = true;
      environmentFile = "/var/lib/vaultwarden/vaultwarden.env";
      config = {
        DOMAIN = "https://vaultwarden.vsinerva.fi";
        LOGIN_RATELIMIT_MAX_BURST = 10;
        LOGIN_RATELIMIT_SECONDS = 60;
        ADMIN_RATELIMIT_MAX_BURST = 10;
        ADMIN_RATELIMIT_SECONDS = 60;
        SENDS_ALLOWED = true;
        EMERGENCY_ACCESS_ALLOWED = true;
        WEB_VAULT_ENABLED = true;
        SIGNUPS_ALLOWED = true;
        SIGNUPS_VERIFY = true;
        SIGNUPS_VERIFY_RESEND_TIME = 3600;
        SIGNUPS_VERIFY_RESEND_LIMIT = 5;
        SMTP_HOST = "smtp.gmail.com";
        SMTP_FROM_NAME = "Vaultwarden";
        SMTP_SECURITY = "force_tls";
        SMTP_PRT = 587;
        SMTP_AUTH_MECHANISM = "Login";
      };
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;

      virtualHosts."vaultwarden.vsinerva.fi" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = "/var/lib/vaultwarden/fullchain.pem";
        sslCertificateKey = "/var/lib/vaultwarden/privkey.pem";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8000";
        };
      };
    };
  };
}
