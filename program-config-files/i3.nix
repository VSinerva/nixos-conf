{ config, pkgs, ... }:
let
  alacritty-conf = "${
    (import ./alacritty.nix {
      inherit config;
      inherit pkgs;
    })
  }";
  i3status-conf = "${pkgs.writeText "i3status-conf" ''
    # It is important that this file is edited as UTF-8.
    # The following line should contain a sharp s:
    # ß
    # If the above line is not correctly displayed, fix your editor first!

    general {
            output_format = "i3bar"
            colors = true
            interval = 1
            color_good = "#2AA198"
            color_bad = "#586E75"
            color_degraded = "#DC322F"
    }

    order += "battery all"
    order += "cpu_usage"
    order += "memory"
    order += "ethernet _first_"
    order += "wireless _first_"
    order += "disk /"
    order += "tztime local"
    order += "tztime helsinki"

    battery all {
            format = " %status %percentage (%remaining @ %consumption) "
            format_down = ""
            last_full_capacity = true
            integer_battery_capacity = true
            low_threshold = 30
            threshold_type = time
    }

    cpu_usage {
            format = " CPU  %usage "
    }

    memory {
            format = " RAM %used / %total "
            threshold_degraded = "10%"
    }

    ethernet _first_ {
            format_up = " LAN: %ip "
            format_down = " No LAN "
    }

    wireless _first_ {
            format_up = " %quality%essid: %ip "
            format_down = ""
    }

    disk "/" {
            format = " ⛁ %avail "
    }

    tztime local {
            format = " %d.%m. %H:%M "
    }

    tztime helsinki {
            format = " (HEL %H:%M) "
            timezone = "Europe/Helsinki"
            hide_if_equals_localtime = true
    }
  ''}";
in
pkgs.writeText "i3-conf" ''
  # Set mod key (Mod1=<Alt>, Mod4=<Super>)
  set $mod Mod1
  set $secondary Mod4



  exec --no-startup-id nm-applet --sm-disable
  for_window [window_type="notification"] floating enable

  # Screen brightness controls
  bindcode 232 exec --no-startup-id brightnessctl set 5%-
  bindcode 233 exec --no-startup-id brightnessctl set 5%+

  bindsym $mod+Return exec "alacritty --config-file ${alacritty-conf}"
  bindsym $mod+Shift+Return exec "alacritty --config-file ${alacritty-conf} --working-directory $PWD"
  bindsym $mod+d exec --no-startup-id "rofi -theme 'Arc-Dark' -show combi -combi-modes 'run' -modes combi"

  bindsym $mod+Shift+p mode "$mode_system"
  set $mode_system (l)ock, (s)uspend, (h)ibernate, (r)eboot, (S)hutdown
  mode "$mode_system" {
        bindsym l exec --no-startup-id i3lock, mode "default"
        bindsym s exec --no-startup-id "i3lock; systemctl suspend", mode "default"
        bindsym h exec --no-startup-id systemctl hibernate, mode "default"
        bindsym r exec --no-startup-id systemctl reboot, mode "default"
        bindsym Shift+s exec --no-startup-id systemctl poweroff, mode "default"
        bindsym Return mode "default"
        bindsym Escape mode "default"
  }



  font xft:DejaVuSansMono-Book 14
  default_border pixel 3
  gaps inner 2 

  bar {
          i3bar_command i3bar
          status_command i3status -c ${i3status-conf}

          ## please set your primary output first. Example: 'xrandr --output eDP1 --primary'
          tray_output primary

          bindsym button4 nop
          bindsym button5 nop

          colors {
                  background #0f212f
                  statusline #d0d0d0
                  separator #d0d0d0

                  #                  border  back.   text
                  active_workspace   #303030 #505050 #d0d0d0
          }
  }



  bindsym $mod+Shift+q kill

  floating_modifier $mod

  bindsym $mod+s split h
  bindsym $mod+v split v

  bindsym $mod+f fullscreen toggle
  bindsym $mod+Shift+space floating toggle
  bindsym $mod+space focus mode_toggle

  bindsym $mod+Shift+c reload
  bindsym $mod+Shift+r restart



  bindsym $mod+h focus left
  bindsym $mod+j focus down
  bindsym $mod+k focus up
  bindsym $mod+l focus right

  bindsym $mod+Shift+h move left
  bindsym $mod+Shift+j move down
  bindsym $mod+Shift+k move up
  bindsym $mod+Shift+l move right

  bindsym $mod+r mode "resize"
  mode "resize" {
          bindsym h resize shrink width 5 px or 5 ppt
          bindsym j resize grow height 5 px or 5 ppt
          bindsym k resize shrink height 5 px or 5 ppt
          bindsym l resize grow width 5 px or 5 ppt

          bindsym Return mode "default"
          bindsym Escape mode "default"
  }



  workspace 1 output primary
  workspace 2 output primary
  workspace 3 output primary
  workspace 4 output primary
  workspace 5 output primary
  workspace 6 output primary
  workspace 7 output primary
  workspace 8 output primary
  workspace 9 output primary
  workspace 10 output primary
  workspace 11 output eDP primary
  workspace 12 output eDP primary
  workspace 13 output eDP primary
  workspace 14 output eDP primary
  workspace 15 output eDP primary
  workspace 16 output eDP primary
  workspace 17 output eDP primary
  workspace 18 output eDP primary

  # switch to workspace
  bindsym $mod+1 workspace 1
  bindsym $mod+2 workspace 2
  bindsym $mod+3 workspace 3
  bindsym $mod+4 workspace 4
  bindsym $mod+5 workspace 5
  bindsym $mod+6 workspace 6
  bindsym $mod+7 workspace 7
  bindsym $mod+8 workspace 8
  bindsym $mod+9 workspace 9
  bindsym $mod+0 workspace 10
  bindsym $mod+$secondary+1 workspace 11
  bindsym $mod+$secondary+2 workspace 12
  bindsym $mod+$secondary+3 workspace 13
  bindsym $mod+$secondary+4 workspace 14
  bindsym $mod+$secondary+5 workspace 15
  bindsym $mod+$secondary+6 workspace 16
  bindsym $mod+$secondary+7 workspace 17
  bindsym $mod+$secondary+8 workspace 18
  bindsym $mod+$secondary+9 workspace 19
  bindsym $mod+$secondary+0 workspace 20

  # Move focused container to workspace
  bindsym $mod+Ctrl+1 move container to workspace 1
  bindsym $mod+Ctrl+2 move container to workspace 2
  bindsym $mod+Ctrl+3 move container to workspace 3
  bindsym $mod+Ctrl+4 move container to workspace 4
  bindsym $mod+Ctrl+5 move container to workspace 5
  bindsym $mod+Ctrl+6 move container to workspace 6
  bindsym $mod+Ctrl+7 move container to workspace 7
  bindsym $mod+Ctrl+8 move container to workspace 8
  bindsym $mod+Ctrl+9 move container to workspace 9
  bindsym $mod+Ctrl+0 move container to workspace 10
  bindsym $mod+$secondary+Ctrl+1 move container to workspace 11
  bindsym $mod+$secondary+Ctrl+2 move container to workspace 12
  bindsym $mod+$secondary+Ctrl+3 move container to workspace 13
  bindsym $mod+$secondary+Ctrl+4 move container to workspace 14
  bindsym $mod+$secondary+Ctrl+5 move container to workspace 15
  bindsym $mod+$secondary+Ctrl+6 move container to workspace 16
  bindsym $mod+$secondary+Ctrl+7 move container to workspace 17
  bindsym $mod+$secondary+Ctrl+8 move container to workspace 18
  bindsym $mod+$secondary+Ctrl+9 move container to workspace 19
  bindsym $mod+$secondary+Ctrl+0 move container to workspace 20

  # Move to workspace with focused container
  bindsym $mod+Shift+1 move container to workspace 1; workspace 1
  bindsym $mod+Shift+2 move container to workspace 2; workspace 2
  bindsym $mod+Shift+3 move container to workspace 3; workspace 3
  bindsym $mod+Shift+4 move container to workspace 4; workspace 4
  bindsym $mod+Shift+5 move container to workspace 5; workspace 5
  bindsym $mod+Shift+6 move container to workspace 6; workspace 6
  bindsym $mod+Shift+7 move container to workspace 7; workspace 7
  bindsym $mod+Shift+8 move container to workspace 8; workspace 8
  bindsym $mod+Shift+9 move container to workspace 9; workspace 9
  bindsym $mod+Shift+0 move container to workspace 10; workspace 10
  bindsym $mod+$secondary+Shift+1 move container to workspace 11; workspace 11
  bindsym $mod+$secondary+Shift+2 move container to workspace 12; workspace 12
  bindsym $mod+$secondary+Shift+3 move container to workspace 13; workspace 13
  bindsym $mod+$secondary+Shift+4 move container to workspace 14; workspace 14
  bindsym $mod+$secondary+Shift+5 move container to workspace 15; workspace 15
  bindsym $mod+$secondary+Shift+6 move container to workspace 16; workspace 16
  bindsym $mod+$secondary+Shift+7 move container to workspace 17; workspace 17
  bindsym $mod+$secondary+Shift+8 move container to workspace 18; workspace 18
  bindsym $mod+$secondary+Shift+9 move container to workspace 19; workspace 19
  bindsym $mod+$secondary+Shift+0 move container to workspace 20; workspace 20
''
