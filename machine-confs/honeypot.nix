{ ... }:
{
  networking.hostName = "honeypot";

  imports = [
    ../base.nix
  ];

  networking.firewall.allowedTCPPorts = [
    80
  ];

  services = {
    nginx = {
      enable = true;
      recommendedGzipSettings = true;

      virtualHosts.localhost = {
        locations."/" = {
          return = "200 '<html><body>It works</body></html>'";
          extraConfig = ''
            default_type text/html;
          '';
        };
      };
    };
  };

  # HARDWARE SPECIFIC
  services.qemuGuest.enable = true;
}
