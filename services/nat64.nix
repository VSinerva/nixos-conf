{ ... }:
{
  networking = {
    jool = {
      enable = true;
      nat64.default = {
        global.pool6 = "64:ff9b::/96"; # Default value made explicit for clarity
      };
    };
  };
}
