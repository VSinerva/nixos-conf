{ pkgs, ... }:
pkgs.writeText "alacritty-conf" ''
  [font]
  size = 13

  [cursor]
  style.shape = "Beam"
  style.blinking = "On"
  blink_timeout = 0
  unfocused_hollow = false

  [keyboard]
  bindings = [
    {key = "+", mods = "Control | Shift", action = "ResetFontSize"},
    {key = "Enter", mods = "Alt | Shift", action = "SpawnNewInstance"},
  ]
''
