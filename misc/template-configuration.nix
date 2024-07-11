{ config, pkgs, ... }:
let
  host = "???";
  stateVersion = "???";

  repo = builtins.fetchGit {
    url = "https://github.com/VSinerva/nixos-conf.git";
    name = "nixos-conf-github";
    ref = "main";
    publicKeys = [
      {
        # helium
        type = "ssh-ed25519";
        key = "AAAAC3NzaC1lZDI1NTE5AAAAIBbGREoK1uVny1s8FK3KZ74Wmaf0VtifhqPyK69C/Gez";
      }
      {
        # lithium
        type = "ssh-ed25519";
        key = "AAAAC3NzaC1lZDI1NTE5AAAAIPivDyDYrCRBHRl9zup1Gj5vtyesOW/XKG/68kA8HLaW";
      }
    ];
  };
in
{
  nix.settings.experimental-features = "verified-fetches";

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
