{ config, ... }:
{
  assertions = [
    {
      assertion = config.services.xserver.enable;
      message = "Game streaming does not work without a desktop!";
    }
  ];

  services.sunshine = {
    enable = true;
    autoStart = true;
    openFirewall = true;
  };
}
