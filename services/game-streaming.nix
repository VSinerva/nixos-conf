# Game streaming software (and possibly services in future)
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    moonlight-qt
    parsec-bin
  ];
}
