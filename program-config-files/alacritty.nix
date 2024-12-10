{ config, pkgs, ... }:
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
    {key = "-", mods = "Alt", action = "DecreaseFontSize"},
    {key = "+", mods = "Alt | Shift", action = "IncreaseFontSize"},
    {key = "=", mods = "Alt", action = "ResetFontSize"},
    {key = "Enter", mods = "Alt | Shift", action = "SpawnNewInstance"},
  ]
''
