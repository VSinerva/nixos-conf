{ config, pkgs, ... }:
let
  Xresources = "${pkgs.writeText "Xresources" ''
    Xft.dpi:       96
    Xft.antialias: true
    Xft.hinting:   true
    Xft.rgba:      rgb
    Xft.autohint:  false
    Xft.hintstyle: hintslight
    Xft.lcdfilter: lcddefault

    Xcursor.theme: xcursor-breeze
    Xcursor.size:                     0
  ''}";
in
{
  assertions = [
    {
      assertion = config.users.users ? "vili";
      message = "User 'vili' needed for desktop!";
    }
  ];

  imports = [ ./program-config-files/firefox.nix ];

  environment.systemPackages = with pkgs; [
    i3status
    rofi
    arandr
    telegram-desktop
    signal-desktop
    discord
    tidal-hifi
    vlc
    pavucontrol
    viewnior
    xfce.mousepad
    pcmanfm
    libreoffice
    evince
    brightnessctl
    networkmanagerapplet
    flameshot
    speedcrunch
    brave

    zotero
    kile
    texliveFull
    imagemagick
    ghostscript
    kdePackages.okular
  ];

  services = {
    displayManager = {
      defaultSession = "none+i3";
      autoLogin.enable = true;
      autoLogin.user = "vili";
    };
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
        sessionCommands = ''${pkgs.xorg.xrdb}/bin/xrdb -merge < ${Xresources}'';
      };
      windowManager.i3 = {
        enable = true;
        configFile = "${
          (import ./program-config-files/i3.nix {
            inherit config;
            inherit pkgs;
          })
        }";
      };
    };

    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.enable = true;

  security.polkit.enable = true;

  xdg.mime.defaultApplications = {
    "application/pdf" = "org.gnome.Evince.desktop";
    "text/plain" = "org.xfce.mousepad.desktop";
    "text/x-tex" = "org.kde.kile.desktop";
    "inode/directory" = "pcmanfm.description";
  };

  qt = {
    enable = true;
    style = "adwaita-dark";
    platformTheme = "gnome";
  };

  system.userActivationScripts.mkDesktopSettingsSymlinks.text =
    let
      home = "/home/vili/";
      paths = [
        rec {
          dir = "${home}.config/pcmanfm/default/";
          file = "pcmanfm.conf";
          full = "${dir}${file}";
          source = "${./program-config-files/pcmanfm.conf}";
        }
        rec {
          dir = "${home}.config/libfm/";
          file = "libfm.conf";
          full = "${dir}${file}";
          source = "${./program-config-files/libfm.conf}";
        }
        rec {
          dir = "${home}.config/gtk-3.0/";
          file = "bookmarks";
          full = "${dir}${file}";
          source = "${./program-config-files/gtk-bookmarks}";
        }
        rec {
          dir = "${home}";
          file = ".gtkrc-2.0";
          full = "${dir}${file}";
          source = "${./program-config-files/gtkrc-2.0}";
        }
        rec {
          dir = "${home}.config/gtk-3.0/";
          file = "settings.ini";
          full = "${dir}${file}";
          source = "${./program-config-files/gtk-3-4-settings.ini}";
        }
        rec {
          dir = "${home}.config/gtk-4.0/";
          file = "settings.ini";
          full = "${dir}${file}";
          source = "${./program-config-files/gtk-3-4-settings.ini}";
        }
      ];
    in
    toString (
      map (path: ''
        mkdir -p ${path.dir}
        if test -e ${path.full} -a ! -L ${path.full}; then
          mv -f ${path.full} ${path.full}.old
        fi
        ln -sf ${path.source} ${path.full}
      '') paths
    );
}
