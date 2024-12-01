{ config, pkgs, ... }:
let
  host = "generic";
  stateVersion = "24.11";

  repo = builtins.fetchGit {
    url = "https://github.com/VSinerva/nixos-conf.git";
    name = "nixos-conf-github";
    ref = "main";
  };
in
{
  imports = [
    ./hardware-configuration.nix
    "${repo}/machine-confs/${host}.nix"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = stateVersion; # Did you read the comment?
}
