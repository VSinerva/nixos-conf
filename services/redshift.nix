{ config, pkgs, ... }:
{
  assertions = [
    {
      assertion = config.services.xserver.enable;
      message = "Redshift does not work without a desktop!";
    }
  ];
  services = {
    redshift = {
      executable = "/bin/redshift-gtk";
      enable = true;
      temperature = {
        night = 2800;
        day = 6500;
      };
      brightness = {
        night = "0.5";
        day = "1";
      };
    };
  };

  location = {
    latitude = 60.17;
    longitude = 24.94;
  };
}
