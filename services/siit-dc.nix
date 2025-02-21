{ ... }:
let
  gua_pref = "2001:14ba:a090:39";
  v4_pref = "192.168.251";
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
            "ipv6 prefix" = "${gua_pref}d1:be24:11ff:fe42:dd76/128";
            "ipv4 prefix" = "${v4_pref}.1/32";
          }
        ];
      };
    };
  };
}
