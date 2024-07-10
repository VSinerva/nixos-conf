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

                        XTerm*background:        #222D31
                        XTerm*foreground:        #d8d8d8
                        XTerm*pointerColor:      #1ABB9B
                        XTerm*faceName:          Fixed
                        XTerm*faceSize:          11
                        XTerm*reverseVideo:      on
                        XTerm*selectToClipboard: true

                        *background:                      #222D31
                        *foreground:                      #d8d8d8
                        *fading:                          8
                        *fadeColor:                       black
                        *cursorColor:                     #1ABB9B
                        *pointerColorBackground:          #2B2C2B
                        *pointerColorForeground:          #16A085

                        !! black dark/light
                        *color0:                          #222D31
                        *color8:                          #585858

                        !! red dark/light
                        *color1:                          #ab4642
                        *color9:                          #ab4642

                        !! green dark/light
                        *color2:                          #7E807E
                        *color10:                         #8D8F8D

                        !! yellow dark/light
                        *color3:                          #f7ca88
                        *color11:                         #f7ca88

                        !! blue dark/light
                        *color4:                          #7cafc2
                        *color12:                         #7cafc2

                        !! magenta dark/light
                        *color5:                          #ba8baf
                        *color13:                         #ba8baf

                        !! cyan dark/light
                        *color6:                          #1ABB9B
                        *color14:                         #1ABB9B

                        !! white dark/light
                        *color7:                          #d8d8d8
                        *color15:                         #f8f8f8

                        Xcursor.theme: xcursor-breeze
                        Xcursor.size:                     0

                        URxvt.font:                       9x15,xft:TerminessTTFNerdFontMono

                        ! alternative font settings with 'terminus':
                        ! URxvt.font:      -xos4-terminus-medium-r-normal--16-160-72-72-c-80-iso10646-1
                        ! URxvt.bold.font: -xos4-terminus-bold-r-normal--16-160-72-72-c-80-iso10646-1
                        !! terminus names see end of file!

                        URxvt.depth:                      32
                        URxvt.background:                 [100]#0f0f0f
    						  URxvt.foreground:                 #a0a0a0
                        URxvt*scrollBar:                  false
                        URxvt*mouseWheelScrollPage:       false
                        URxvt*cursorBlink:                true
                        URxvt*background:                 black
                        URxvt*saveLines:                  5000

                        ! for 'fake' transparency (without Compton) uncomment the following three lines
                        ! URxvt*inheritPixmap:            true
                        ! URxvt*transparent:              true
                        ! URxvt*shading:                  138

                        ! Normal copy-paste keybindings without perls
                        URxvt.iso14755:                   false
                        URxvt.keysym.Shift-Control-V:     eval:paste_clipboard
                        URxvt.keysym.Shift-Control-C:     eval:selection_to_clipboard
                        !Xterm escape codes, word by word movement
                        URxvt.keysym.Control-Left:        \033[1;5D
                        URxvt.keysym.Shift-Control-Left:  \033[1;6D
                        URxvt.keysym.Control-Right:       \033[1;5C
                        URxvt.keysym.Shift-Control-Right: \033[1;6C
                        URxvt.keysym.Control-Up:          \033[1;5A
                        URxvt.keysym.Shift-Control-Up:    \033[1;6A
                        URxvt.keysym.Control-Down:        \033[1;5B
                        URxvt.keysym.Shift-Control-Down:  \033[1;6B
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
