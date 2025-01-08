{ ... }:
{
  # Give NAT64 internet without DNS64
  environment.etc."resolv.conf".text = ''
    search vsinerva.fi
    nameserver 2606:4700:4700::1111
    nameserver 2606:4700:4700::1001
    nameserver 1.1.1.1
    nameserver 1.0.0.1
  '';

  networking = {
    jool = {
      enable = true;
      nat64.default = {
        global.pool6 = "64:ff9b::/96"; # Default value made explicit for clarity

        # Port forwarding
        bib = [
          {
            # ExoPlaSim WireGuard
            "protocol" = "UDP";
            "ipv4 address" = "192.168.1.1#51821";
            "ipv6 address" = "fd08:d473:bcca:1:210:3292:4922:b9aa#51821";
          }
        ];

        pool4 = [
          # Ports for static BIB entries
          {
            protocol = "UDP";
            prefix = "192.168.1.1/32";
            "port range" = "51821";
          }

          # Port ranges for dynamic translation
          {
            protocol = "TCP";
            prefix = "192.168.1.1/32";
            "port range" = "30001-50000";
          }
          {
            protocol = "UDP";
            prefix = "192.168.1.1/32";
            "port range" = "30001-50000";
          }
          {
            protocol = "ICMP";
            prefix = "192.168.1.1/32";
            "port range" = "30001-50000";
          }
        ];
      };
    };
  };
}
