{ pkgs, config, ... }:
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
    settings = {
      sunshine_name = "Gaming NixOS";
      resolutions = [
        [
          "1920x1080"
          "2400x1080"
          "2160x1440"
          "2560x1440"
          "3840x2160"
        ]
      ];
      fps = [
        30
        60
        90
        120
      ];
      address_family = "both";
    };
    applications = {
      apps =
        resolution:
        map {
          name = "${resolution} Desktop";
          #          prep-cmd = [
          #            {
          #              do = "${pkgs.xrandr}/bin/kscreen-doctor output.DP-4.mode.2560x1440@144";
          #              undo = "${pkgs.xrandr}/bin/kscreen-doctor output.DP-4.mode.3440x1440@144";
          #            }
          #          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        } config.services.sunshine.settings.resolutions;
    };
  };
}
