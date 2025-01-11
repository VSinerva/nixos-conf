{ pkgs, config, ... }:
let
  sunshineCuda = pkgs.sunshine.override {
    cudaSupport = true;
    stdenv = pkgs.cudaPackages.backendStdenv;
  };
  resolution_list = [
    "1920x1080"
    "2400x1080"
    "2160x1440"
    "2560x1440"
    "3840x2160"
  ];
in
{
  assertions = [
    {
      assertion = config.services.xserver.enable;
      message = "Game streaming does not work without a desktop!";
    }
  ];

  services.sunshine = {
    package = sunshineCuda;
    enable = true;
    autoStart = true;
    openFirewall = true;
    settings = {
      min_log_level = "debug";
      encoder = "nvenc";
      sunshine_name = "Gaming NixOS";
      resolutions = ''
        [
          1920x1080,
          2400x1080,
          2160x1440,
          2560x1440,
          3840x2160
        ]
      '';
      fps = ''
        [30, 60, 90, 120]
      '';
      address_family = "both";
    };
    applications = {
      apps =
        (
          resolutions:
          map (resolution: {
            name = "${resolution} Desktop";
            prep-cmd = [
              {
                do = "${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --mode ${resolution}";
                undo = "${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --auto";
              }
            ];
            exclude-global-prep-cmd = "false";
            auto-detach = "true";
          }) resolutions
        )
          resolution_list;
    };
  };
}
