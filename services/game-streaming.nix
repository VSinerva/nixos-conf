# Game streaming software (and possibly services in future)
{ config, pkgs, ... }:
{
  assertions = [
    {
      assertion = config.services.xserver.enable;
      message = "Game streaming does not work without a desktop!";
    }
  ];

  environment.systemPackages = with pkgs; [
    moonlight-qt
    parsec-bin
  ];
}
