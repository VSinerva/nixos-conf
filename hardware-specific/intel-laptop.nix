{ config, pkgs, ... }:
{
  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
    ];
  };

  services.logind.lidSwitch = if config.boot.resumeDevice != "" then "hibernate" else "suspend";
}
