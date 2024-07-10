#Config for graphical desktop
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

  environment.systemPackages = with pkgs; [
    i3status
    rofi
    arandr
    btop
    firefox
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
    zotero
    flameshot
    speedcrunch
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
        configFile = ./program-config-files/i3.conf;
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

  programs.firefox = {
    preferences = {
      "media.ffmpeg.vaapi.enabled" = true;
    };
    enable = true;
    preferencesStatus = "locked";
    policies = {
      ExtensionSettings = {
        "*".installation_mode = "blocked";
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

  qt = {
    enable = true;
    style = "breeze";
  };

  systemd.services.i3statusSymlink = {
    wantedBy = [ "multi-user.target" ];
    description = "Symlink for i3status";
    serviceConfig = {
      Type = "oneshot";
      User = "vili";
      ExecStartPre = ''${pkgs.coreutils-full}/bin/mkdir -p /home/vili/.config/i3status'';
      ExecStart = ''${pkgs.coreutils-full}/bin/ln -sf ${./program-config-files/i3status.conf} /home/vili/.config/i3status/config'';
    };
  };

  xdg.mime.defaultApplications = {
    "application/pdf" = "org.gnome.Evince.desktop";
    "text/plain" = "org.xfce.mousepad.desktop";
    "inode/directory" = "pcmanfm.description";
  };

  security.polkit.enable = true;
}
