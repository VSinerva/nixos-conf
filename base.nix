{ config, pkgs, ... }:
{
  ######################################## Packages ###############################################
  environment.systemPackages = with pkgs; [
    alacritty
    tmux
    git
    nvi
    p7zip
    tree
    btop
  ];

  ######################################## ZSH configuration ######################################
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

  ######################################## tmux configuration #####################################
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

  ######################################## SSH and fail2ban configuration #########################
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBbGREoK1uVny1s8FK3KZ74Wmaf0VtifhqPyK69C/Gez vili@helium"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPivDyDYrCRBHRl9zup1Gj5vtyesOW/XKG/68kA8HLaW vili@lithium"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPiupf3xK6eWvno7R2rDYPuDxVvbmzWh5EkR1rquvV9hAAAABHNzaDo= vili@helium"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOOk8akyi6Ob1EOPugxnjdlMQs9rOAbxBbakT8olBFe7 backup_ssh"
  ];

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

  ######################################## Localization ###########################################
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us,";
    variant = "de_se_fi,";
  };
  console = pkgs.lib.mkForce {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };
  time.timeZone = "Europe/Helsinki";

  ######################################## Memory management ######################################
  zramSwap.enable = true;
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];

  ######################################## Housekeeping ###########################################
  system.autoUpgrade = {
    enable = true;
    dates = "04:00";
    randomizedDelaySec = "30min";
    allowReboot = true;
    rebootWindow = {
      lower = "03:30";
      upper = "05:00";
    };
  };

  nix = {
    package = pkgs.nixVersions.nix_2_20;
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

  # Define systemd template unit for reporting status via ntfy
  systemd.services =
    let
      services = [ "nixos-upgrade" ];
    in
    {
      "notify-push@" = {
        environment.SERVICE_ID = "%i";
        path = [
          "/run/wrappers"
          "/run/current-system/sw"
        ];
        script = ''
          curl \
            -H "Title:$(hostname) $SERVICE_ID $(systemctl show --property=Result $SERVICE_ID)" \
            -d "$(journalctl --output cat -n 2 -u $SERVICE_ID)" \
            https://ntfy.vsinerva.fi/service-notifs
        '';
      };

      # Merge attributes for all monitored services
    }
    // (pkgs.lib.attrsets.genAttrs services (name: {
      onFailure = pkgs.lib.mkBefore [ "notify-push@%i.service" ];
      onSuccess = pkgs.lib.mkBefore [ "notify-push@%i.service" ];
    }));

  ######################################## Misc. ##################################################
  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.tempAddresses = "disabled";

  users.mutableUsers = false; # Force all user management to happen throught nix-files

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "8192";
    }
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = pkgs.lib.mkDefault 0;
  };
  services.logind.lidSwitch = if config.boot.resumeDevice != "" then "hibernate" else "suspend";
}
