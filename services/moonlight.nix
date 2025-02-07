{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    moonlight-qt
    parsec-bin
  ];
}
