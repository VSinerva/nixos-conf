# Nextcloud instance
{ config, pkgs, ... }:
{
	networking.firewall.allowedTCPPorts = [ 80 443 ];
	networking.firewall.allowedUDPPorts = [ 443 ];

	services.nextcloud = {
		package = pkgs.nextcloud29;
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

	services.nginx.virtualHosts =
	{
		${config.services.nextcloud.hostName} = {
			forceSSL = true;
			kTLS = true;
			sslCertificate = "/var/lib/nextcloud/nextcloud_fullchain.pem";
			sslCertificateKey = "/var/lib/nextcloud/nextcloud_privkey.pem";
			locations = { 
				"/".proxyWebsockets = true;
				"~ ^\/nextcloud\/(?:index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|oc[ms]-provider\/.+|.+\/richdocumentscode\/proxy)\.php(?:$|\/)" = {};
			};
		};
	};

  services.nginx.virtualHosts."collabora.vsinerva.fi" =
  {
	forceSSL = true;
	sslCertificate = "/var/lib/nextcloud/collabora_fullchain.pem";
	sslCertificateKey = "/var/lib/nextcloud/collabora_privkey.pem";
    locations = {
      # static files
      "^~ /loleaflet" = {
        proxyPass = "https://localhost:9980";
        extraConfig = ''
          proxy_set_header Host $host;
        '';
      };
      # WOPI discovery URL
      "^~ /hosting/discovery" = {
        proxyPass = "https://localhost:9980";
        extraConfig = ''
          proxy_set_header Host $host;
        '';
      };

      # Capabilities
      "^~ /hosting/capabilities" = {
        proxyPass = "https://localhost:9980";
        extraConfig = ''
          proxy_set_header Host $host;
        '';
      };

      # download, presentation, image upload and websocket
      "~ ^/lool" = {
        proxyPass = "https://localhost:9980";
        extraConfig = ''
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "Upgrade";
          proxy_set_header Host $host;
          proxy_read_timeout 36000s;
        '';
      };

      # Admin Console websocket
      "^~ /lool/adminws" = {
        proxyPass = "https://localhost:9980";
        extraConfig = ''
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "Upgrade";
          proxy_set_header Host $host;
          proxy_read_timeout 36000s;
        '';
      };
    };
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers.collabora = {
      image = "collabora/code";
      ports = ["9980:9980"];
      environment = {
        domain = "collabora.vsinerva.fi";
        extra_params = "--o:ssl.enable=true --o:ssl.termination=true";
      };
      extraOptions = ["--cap-add" "MKNOD"];
    };
  };
}
