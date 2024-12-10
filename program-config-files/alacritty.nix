{ config, pkgs, ... }:
pkgs.writeText "alacritty-conf" ''
  [font]
  size = 16

  [cursor]
  shape = "Beam"
  blinking = "On"

  [keyboard]
  bindings = [
    {key = "-", mods = "Super", action = "DecreaseFontSize"},
    {key = "+", mods = "Super", action = "IncreaseFontSize"},
    {key = "=", mods = "Super", action = "ResetFontSize"},
    {key = "Enter", mods = "Super | Shift", action = "SpawnNewInstance"},
  ]
''
