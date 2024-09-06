{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [ 443 ];

  services.ntfy = {
    enable = true;
    settings = {
      base-url = "https://ntfy.vsinerva.fi";
      listen-https = ":443";
      key-file = "/var/lib/ntfy/privkey.pem";
      cert-file = "/var/lib/ntfy/fullchain.pem";
      cache-file = "/var/lib/ntfy/notif-cache.sqlite";
    };
  };
}
