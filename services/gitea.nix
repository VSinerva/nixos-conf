{ config, ... }:
{
  imports = [ ./acme-dns.nix ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [ 443 ];

  services = {
    gitea = {
      enable = true;
      lfs.enable = true;
      appName = "Gitea for Vili Sinervä";
      mailerPasswordFile = "${config.services.gitea.stateDir}/smtp_pass"; # TODO

      settings = {
        repository = {
          ENABLE_PUSH_CREATE_USER = true;
        };
        ui = {
          DEFAULT_SHOW_FULL_NAME = true;
          meta.AUTHOR = "Gitea, hosted by Vili Sinervä";
        };
        server = {
          DOMAIN = "gitea.vsinerva.fi";
          HTTP_PORT = 8000;
          ROOT_URL = "https://${config.services.gitea.settings.server.DOMAIN}";
        };
        # service.DISABLE_REGISTRATION = true; # Disable for initial setup
        session.COOKIE_SECURE = true;
        mailer = {
          ENABLED = true;
          SMTP_ADDR = "smtp.gmail.com";
          SMTP_PORT = 587;
          USER = "vmsskv12@gmail.com"; # Password set in file
          FROM = "gitea@vsinerva.fi";
        };
        cron = {
          ENABLED = true;
          RUN_AT_START = true;
        };
        time.DEFAULT_UI_LOCATION = "Europe/Helsinki";
      };
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;

      virtualHosts.${config.services.gitea.settings.server.DOMAIN} = {
        forceSSL = true;
        kTLS = true;
        enableACME = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "http://localhost:8000";
        };
      };
    };
  };
}
