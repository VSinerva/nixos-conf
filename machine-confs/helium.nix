{
  config,
  pkgs,
  lib,
  ...
}:
{
  networking = {
    hostName = "helium";
    firewall.allowedUDPPorts = [
      51820
      51821
    ];
    wg-quick.interfaces = {
      wg0 = {
        autostart = false;
        address = [ "172.16.0.2/24" ];
        dns = [
          "192.168.0.1"
          "vsinerva.fi"
        ];
        privateKeyFile = "/root/wireguard-keys/privatekey-home";
        listenPort = 51820;

        peers = [
          {
            publicKey = "f9QoYPxyaxylUcOI9cE9fE9DJoEX4c6GUtr4p+rsd34=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "wg.vsinerva.fi:51820";
          }
        ];
      };
      wg1 = {
        autostart = false;
        address = [ "10.100.0.7/24" ];
        dns = [ "1.1.1.1" ];
        privateKeyFile = "/root/wireguard-keys/privatekey-netflix";
        listenPort = 51821;

        peers = [
          {
            publicKey = "XSYHg0utIR1j7kRsWFwuWNo4RPD47KP53cVa6qDPtRE=";
            allowedIPs = [
              "0.0.0.0/0"
              "192.168.0.0/24"
            ];
            endpoint = "netflix.vsinerva.fi:51821";
          }
        ];
      };
    };
  };

  nix.settings = {
    cores = 3;
    max-jobs = 4;
  };

  imports = [
    ../base.nix
    ../users/vili.nix
    ../services/syncthing.nix
    ../desktop.nix
    ../development.nix
    ../misc/libinput.nix
  ];
  disabledModules = [ "services/hardware/libinput.nix" ];

  nixpkgs.overlays = [
    (final: prev: {
      moonlight-qt = prev.moonlight-qt.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ../misc/mouse-accel.patch ];
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    zenmonitor
    moonlight-qt
    parsec-bin
    via
  ];

  # HARDWARE SPECIFIC
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware = {
    opengl.extraPackages = with pkgs; [ rocmPackages.clr.icd ];
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  services = {
    xserver = {
      videoDrivers = [
        "amdgpu"
        "modesetting"
      ];
      deviceSection = ''
        Option "DRI" "2"
        Option "TearFree" "true"
      '';

      displayManager.setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output DisplayPort-0 --auto --pos 0x0 --primary --output eDP --auto --pos 3840x360
      '';
    };

    libinput.mouse = {
      accelProfile = "custom";
      accelPointsMotion = [
        0.0
        2.0e-2
        4.0e-2
        6.0e-2
        8.0e-2
        0.1
        0.12
        0.14
        0.16
        0.18
        0.2
        0.2525
        0.31
        0.3725
        0.44
        0.5125
        0.59
        0.6725
        0.76
        0.8525
        0.95
        1.155
        1.37
        1.595
        1.83
        2.075
        2.33
        2.595
        2.87
        3.155
        3.45
        3.755
        4.07
        4.395
        4.73
        5.075
        5.43
        5.795
        6.17
        6.555
        6.95
        7.355
        7.77
        8.195
        8.63
        9.075
        9.53
        9.995
        10.47
        10.955
        11.45
        11.95
      ];
      accelStepMotion = 5.0e-2;
    };

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

    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };
  location = {
    latitude = 60.17;
    longitude = 24.94;
  };

  # Swap + hibernate
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];
  boot.resumeDevice = "/dev/mapper/luks-f6e1979b-0dee-4ee9-8170-10490019854b";
  boot.kernelParams = [ "resume_offset=44537856" ];
  services.logind = {
    lidSwitch = "hibernate";
  };

  # Keychron Q11
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="01e0", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
