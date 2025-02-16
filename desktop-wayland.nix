{ config, pkgs, ... }:
{
  assertions = [
    {
      assertion = config.users.users ? "vili";
      message = "User 'vili' needed for desktop!";
    }
  ];

  imports = [
    ./program-config-files/firefox.nix
    ./program-config-files/sway.nix
  ];

  environment.systemPackages = with pkgs; [
    telegram-desktop
    signal-desktop
    discord
    tidal-hifi
    vlc
    viewnior
    xfce.mousepad
    pcmanfm
    libreoffice
    evince
    networkmanagerapplet
    flameshot
    speedcrunch

    zotero
    kile
    texliveFull
    imagemagick
    ghostscript
    kdePackages.okular
  ];

  services = {
    gnome.gnome-keyring.enable = true;
    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${pkgs.sway}/bin/sway";
          user = "vili";
        };
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "greeter";
        };
      };
    };
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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
