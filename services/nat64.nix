{ ... }:
{
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
            "ipv4 address" = "192.168.1.2#51821";
            "ipv6 address" = "fd08:d473:bcca:1:210:3292:4922:b9aa#51821";
          }
        ];

        pool4 = [
          # Ports for static BIB entries
          {
            protocol = "UDP";
            prefix = "192.168.1.2/32";
            "port range" = "51821";
          }

          # Port ranges for dynamic translation
          {
            protocol = "TCP";
            prefix = "192.168.1.2/32";
            "port range" = "61001-65535";
          }
          {
            protocol = "UDP";
            prefix = "192.168.1.2/32";
            "port range" = "61001-65535";
          }
          {
            protocol = "ICMP";
            prefix = "192.168.1.2/32";
            "port range" = "61001-65535";
          }
        ];
      };
    };
  };
}
