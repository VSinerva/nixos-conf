#Basic system config
{ config, pkgs, ... }:
{
  #################### Packages ####################
  environment.systemPackages = with pkgs; [
    alacritty
    tmux
    git
    nvi
    p7zip
    tree
    btop
  ];

  #################### ZSH configuration ####################
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "history-substring-search"
        "tmux"
      ];
      theme = "af-magic";
    };
    interactiveShellInit = ''
      ZSH_TMUX_AUTOSTART=false
      ZSH_TMUX_AUTOQUIT=false
      ZSH_TMUX_CONFIG=/etc/tmux.conf
    '';
    promptInit = ''
      if [ -n "$IN_NIX_SHELL" ]; then 
        setopt PROMPT_SUBST
        RPROMPT+='[nix]'
      fi
    '';
  };

  #################### tmux configuration ####################
  programs.tmux.enable = true;
  programs.tmux.extraConfig = ''
    unbind C-b
    set -g prefix M-w
    bind M-w send-prefix

    bind s split-window -v
    bind v split-window -h

    # Smart pane switching with awareness of Vim splits.
    bind -n C-h run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-h) || tmux select-pane -L"
    bind -n C-j run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-j) || tmux select-pane -D"
    bind -n C-k run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-k) || tmux select-pane -U"
    bind -n C-l run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-l) || tmux select-pane -R"

    bind -n C-Left select-pane -L
    bind -n C-Right select-pane -R
    bind -n C-Up select-pane -U
    bind -n C-Down select-pane -D

    # resize panes more easily
    bind -r h resize-pane -L 10
    bind -r j resize-pane -D 10
    bind -r k resize-pane -U 10
    bind -r l resize-pane -R 10

    bind M-c attach -c "#{pane_current_path}" 

    set -s escape-time 0
  '';

  #################### SSH configuration ####################
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBbGREoK1uVny1s8FK3KZ74Wmaf0VtifhqPyK69C/Gez vili@helium"
  ];

  #################### Basic fail2ban configuration ####################
  services.fail2ban = {
    enable = true;
    bantime = "1h";
    bantime-increment = {
      enable = true;
      factor = "2";
      formula = "ban.Time * (1 << (min(ban.Count, 6) * banFactor))";
      maxtime = "90d";
    };
    jails = {
      DEFAULT.settings = {
        findtime = 3600;
      };
    };
  };

  #################### BASE ####################
  nixpkgs.config.allowUnfree = true;
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  users.mutableUsers = false; # Force all user management to happen throught nix-files

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us,";
    variant = "de_se_fi,";
  };
  console = pkgs.lib.mkForce {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };
  time.timeZone = "Europe/Helsinki";

  #################### Housekeeping ####################
  system.autoUpgrade = {
    enable = true;
    dates = "04:00";
    randomizedDelaySec = "30min";
  };

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      auto-optimise-store = true;
      tarball-ttl = 0;
      experimental-features = "verified-fetches";
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      dates = "05:00";
      randomizedDelaySec = "30min";
    };
  };
}
