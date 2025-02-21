{ ... }:
let
  gua_pref = "2001:14ba:a090:39";
in
{
  networking = {
    jool = {
      enable = true;
      siit.default = {
        global.pool6 = "${gua_pref}46::/96";

        # Explicit address mappings
        eamt = [
          {
            "ipv6 prefix" = "${gua_pref}d1:f0bf:efb:c23:b751/128";
            "ipv4 prefix" = "192.168.250.2/32";
          }
        ];
      };
    };
  };
}
