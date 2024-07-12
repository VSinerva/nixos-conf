{ config, pkgs, ... }:
let
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
  set $mod Mod4

  # Workspace names
  # to display names or symbols instead of plain workspace numbers you can use
  set $ws1 1
  set $ws2 2
  set $ws3 3
  set $ws4 4
  set $ws5 5
  set $ws6 6
  set $ws7 7
  set $ws8 8
  set $ws9 9
  set $ws10 10
  set $ws11 11
  set $ws12 12
  set $ws13 13
  set $ws14 14
  set $ws15 15
  set $ws16 16
  set $ws17 17
  set $ws18 18
  set $ws19 19
  set $ws20 20

  # switch to workspace
  bindsym $mod+1 workspace $ws1
  bindsym $mod+2 workspace $ws2
  bindsym $mod+3 workspace $ws3
  bindsym $mod+4 workspace $ws4
  bindsym $mod+5 workspace $ws5
  bindsym $mod+6 workspace $ws6
  bindsym $mod+7 workspace $ws7
  bindsym $mod+8 workspace $ws8
  bindsym $mod+9 workspace $ws9
  bindsym $mod+0 workspace $ws10
  bindsym $mod+Mod1+1 workspace $ws11
  bindsym $mod+Mod1+2 workspace $ws12
  bindsym $mod+Mod1+3 workspace $ws13
  bindsym $mod+Mod1+4 workspace $ws14
  bindsym $mod+Mod1+5 workspace $ws15
  bindsym $mod+Mod1+6 workspace $ws16
  bindsym $mod+Mod1+7 workspace $ws17
  bindsym $mod+Mod1+8 workspace $ws18
  bindsym $mod+Mod1+9 workspace $ws19
  bindsym $mod+Mod1+0 workspace $ws20

  # Move focused container to workspace
  bindsym $mod+Ctrl+1 move container to workspace $ws1
  bindsym $mod+Ctrl+2 move container to workspace $ws2
  bindsym $mod+Ctrl+3 move container to workspace $ws3
  bindsym $mod+Ctrl+4 move container to workspace $ws4
  bindsym $mod+Ctrl+5 move container to workspace $ws5
  bindsym $mod+Ctrl+6 move container to workspace $ws6
  bindsym $mod+Ctrl+7 move container to workspace $ws7
  bindsym $mod+Ctrl+8 move container to workspace $ws8
  bindsym $mod+Ctrl+9 move container to workspace $ws9
  bindsym $mod+Ctrl+0 move container to workspace $ws10
  bindsym $mod+Mod1+Ctrl+1 move container to workspace $ws11
  bindsym $mod+Mod1+Ctrl+2 move container to workspace $ws12
  bindsym $mod+Mod1+Ctrl+3 move container to workspace $ws13
  bindsym $mod+Mod1+Ctrl+4 move container to workspace $ws14
  bindsym $mod+Mod1+Ctrl+5 move container to workspace $ws15
  bindsym $mod+Mod1+Ctrl+6 move container to workspace $ws16
  bindsym $mod+Mod1+Ctrl+7 move container to workspace $ws17
  bindsym $mod+Mod1+Ctrl+8 move container to workspace $ws18
  bindsym $mod+Mod1+Ctrl+9 move container to workspace $ws19
  bindsym $mod+Mod1+Ctrl+0 move container to workspace $ws20

  # Move to workspace with focused container
  bindsym $mod+Shift+1 move container to workspace $ws1; workspace $ws1
  bindsym $mod+Shift+2 move container to workspace $ws2; workspace $ws2
  bindsym $mod+Shift+3 move container to workspace $ws3; workspace $ws3
  bindsym $mod+Shift+4 move container to workspace $ws4; workspace $ws4
  bindsym $mod+Shift+5 move container to workspace $ws5; workspace $ws5
  bindsym $mod+Shift+6 move container to workspace $ws6; workspace $ws6
  bindsym $mod+Shift+7 move container to workspace $ws7; workspace $ws7
  bindsym $mod+Shift+8 move container to workspace $ws8; workspace $ws8
  bindsym $mod+Shift+9 move container to workspace $ws9; workspace $ws9
  bindsym $mod+Shift+0 move container to workspace $ws10; workspace $ws10
  bindsym $mod+Mod1+Shift+1 move container to workspace $ws11; workspace $ws11
  bindsym $mod+Mod1+Shift+2 move container to workspace $ws12; workspace $ws12
  bindsym $mod+Mod1+Shift+3 move container to workspace $ws13; workspace $ws13
  bindsym $mod+Mod1+Shift+4 move container to workspace $ws14; workspace $ws14
  bindsym $mod+Mod1+Shift+5 move container to workspace $ws15; workspace $ws15
  bindsym $mod+Mod1+Shift+6 move container to workspace $ws16; workspace $ws16
  bindsym $mod+Mod1+Shift+7 move container to workspace $ws17; workspace $ws17
  bindsym $mod+Mod1+Shift+8 move container to workspace $ws18; workspace $ws18
  bindsym $mod+Mod1+Shift+9 move container to workspace $ws19; workspace $ws19
  bindsym $mod+Mod1+Shift+0 move container to workspace $ws20; workspace $ws20

  # Configure border style <normal|1pixel|pixel xx|none|pixel>
  default_border pixel 3
  default_floating_border normal

  # Hide borders
  hide_edge_borders none

  # Font for window titles. Will also be used by the bar unless a different font
  # is used in the bar {} block below.
  font xft:URWGothic-Book 14

  # Use Mouse+$mod to drag floating windows
  floating_modifier $mod

  # start a terminal
  bindsym $mod+Return exec alacritty

  # kill focused window
  bindsym $mod+Shift+q kill

  # start program launcher
  bindsym $mod+d exec --no-startup-id "rofi -theme 'Arc-Dark' -show combi -combi-modes 'run,ssh' -modes combi"

  # change focus
  bindsym $mod+h focus left
  bindsym $mod+j focus down
  bindsym $mod+k focus up
  bindsym $mod+l focus right

  # alternatively, you can use the cursor keys:
  bindsym $mod+Left focus left
  bindsym $mod+Down focus down
  bindsym $mod+Up focus up
  bindsym $mod+Right focus right

  # move focused window
  bindsym $mod+Shift+h move left
  bindsym $mod+Shift+j move down
  bindsym $mod+Shift+k move up
  bindsym $mod+Shift+l move right

  # alternatively, you can use the cursor keys:
  bindsym $mod+Shift+Left move left
  bindsym $mod+Shift+Down move down
  bindsym $mod+Shift+Up move up
  bindsym $mod+Shift+Right move right

  # split orientation
  bindsym $mod+e split h;exec notify-send 'tile horizontally'
  bindsym $mod+v split v;exec notify-send 'tile vertically'

  # toggle fullscreen mode for the focused container
  bindsym $mod+f fullscreen toggle

  # change container layout (stacked, tabbed, toggle split)
  bindsym $mod+s layout stacking
  bindsym $mod+w layout tabbed

  # toggle tiling / floating
  bindsym $mod+Shift+space floating toggle

  # change focus between tiling / floating windows
  bindsym $mod+space focus mode_toggle

  # reload the configuration file
  bindsym $mod+Shift+c reload

  # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
  bindsym $mod+Shift+r restart

  # Resize window (you can also use the mouse for that)
  bindsym $mod+r mode "resize"
  mode "resize" {
  	bindsym h resize shrink width 5 px or 5 ppt
  		bindsym j resize grow height 5 px or 5 ppt
  		bindsym k resize shrink height 5 px or 5 ppt
  		bindsym l resize grow width 5 px or 5 ppt

  # same bindings, but for the arrow keys
  		bindsym Left resize shrink width 10 px or 10 ppt
  		bindsym Down resize grow height 10 px or 10 ppt
  		bindsym Up resize shrink height 10 px or 10 ppt
  		bindsym Right resize grow width 10 px or 10 ppt

  # exit resize mode: Enter or Escape
  		bindsym Return mode "default"
  		bindsym Escape mode "default"
  }

  # Color palette used for the terminal ( ~/.Xresources file )
  # Colors are gathered based on the documentation:
  # https://i3wm.org/docs/userguide.html#xresources
  # Change the variable name at the place you want to match the color
  # of your terminal like this:
  # [example]
  # If you want your bar to have the same background color as your 
  # terminal background change the line 362 from:
  # background #14191D
  # to:
  # background $term_background
  # Same logic applied to everything else.
  set_from_resource $term_background background
  set_from_resource $term_foreground foreground

  # Start i3bar to display a workspace bar (plus the system information i3status if available)
  bar {
  	i3bar_command i3bar
  		status_command i3status -c ${i3status-conf}
  		position bottom

  ## please set your primary output first. Example: 'xrandr --output eDP1 --primary'
  		tray_output primary

  		bindsym button4 nop
  		bindsym button5 nop
  		strip_workspace_numbers yes

  		colors {
  			background #222D31
  				statusline #F9FAF9
  				separator  #454947

  #                      border  backgr. text
  				focused_workspace  #F9FAF9 #16a085 #292F34
  				active_workspace   #595B5B #353836 #FDF6E3
  				inactive_workspace #595B5B #222D31 #EEE8D5
  				binding_mode       #16a085 #2C2C2C #F9FAF9
  				urgent_workspace   #16a085 #FDF6E3 #E5201D
  		}
  }

  # Theme colors
  # class                   border  backgr. text    indic.   child_border
  client.focused          #556064 #556064 #80FFF9 #FDF6E3
  client.focused_inactive #2F3D44 #2F3D44 #1ABC9C #454948
  client.unfocused        #2F3D44 #2F3D44 #1ABC9C #454948
  client.urgent           #CB4B16 #FDF6E3 #1ABC9C #268BD2
  client.placeholder      #000000 #0c0c0c #ffffff #000000 

  client.background       #2B2C2B

  #############################
  ### settings for i3-gaps: ###
  #############################

  # Set inner/outer gaps
  gaps inner 2 
  gaps outer 0

  # Smart gaps (gaps used if only more than one container on the workspace)
  smart_gaps on

  # Smart borders (draw borders around container only if it is not the only container on this workspace)
  smart_borders on

  # Screen brightness controls
  bindcode 232 exec brightnessctl set 5%-
  bindcode 233 exec --no-startup-id brightnessctl set 5%+

  exec --no-startup-id nm-applet --sm-disable
''
