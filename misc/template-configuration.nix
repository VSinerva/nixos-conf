{ config, pkgs, ... }:
let
  host = "generic";
  stateVersion = "24.05";

  repo = builtins.fetchGit {
    url = "https://github.com/VSinerva/nixos-conf.git";
    name = "nixos-conf-github";
    ref = "main";
    publicKeys = [
      {
        # helium
        type = "ssh-ed25519-sk";
        key = "AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPiupf3xK6eWvno7R2rDYPuDxVvbmzWh5EkR1rquvV9hAAAABHNzaDo=";
      }
      {
        # lithium
        type = "ssh-ed25519-sk";
        key = "AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHr/1uVk5cWRWAELvwVvBG+eAbkKqpH2gat1yKKO11roAAAABHNzaDo=";
      }
      {
        # backup
        type = "ssh-ed25519";
        key = "AAAAC3NzaC1lZDI1NTE5AAAAIOOk8akyi6Ob1EOPugxnjdlMQs9rOAbxBbakT8olBFe7";
      }
    ];
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
