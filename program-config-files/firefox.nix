{ config, pkgs, ... }:
let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
  programs.firefox = {
    enable = true;
    preferencesStatus = "locked";

    # ---- POLICIES ----
    # Check about:policies#documentation for options.
    policies = {
      # ---- EXTENSIONS ----
      # Check about:support for extension/add-on ID strings.
      # Valid strings for installation_mode are "allowed", "blocked",
      # "force_installed" and "normal_installed".
      ExtensionSettings = {
        "*".installation_mode = "blocked";
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };

      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableFirefoxStudies = true;
      DisableFormHistory = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      DNSOverHTTPS = {
        Enabled = true;
        Locked = true;
        ProviderURL = pkgs.lib.mkDefault "192.168.0.1";
        Fallback = true;
      };
      DontCheckDefaultBrowser = true;
      DownloadDirectory = "\${home}/Downloads";
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
      FirefoxHome = {
        Locked = true;
        Search = true;
        TopSites = true;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
      };
      FirefoxSuggest = {
        Locked = true;
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
      };
      HardwareAccelerations = true;
      Homepage = {
        Locked = true;
        URL = "https://www.google.com/";
        StartPage = "previous-session";
      };
      HttpsOnlyMode = "force_enabled";
      NetworkPrediction = false;
      NoDefaultBookmarks = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      PasswordManagerEnabled = false;
      Permissions = {
        Camera = {
          Allow = [ ];
          Block = [ ];
          BlockNewRequests = false;
          Locked = true;
        };
        Microphone = {
          Allow = [ ];
          Block = [ ];
          BlockNewRequests = false;
          Locked = true;
        };
        Location = {
          Allow = [ ];
          Block = [ ];
          BlockNewRequests = false;
          Locked = true;
        };
        Notifications = {
          Allow = [ ];
          Block = [ ];
          BlockNewRequests = false;
          Locked = true;
        };
        Autoplay = {
          Allow = [ ];
          Block = [ ];
          BlockNewRequests = false;
          Default = "block-audio-video";
          Locked = true;
        };
      };
      PictureInPicture = {
        Enabled = true;
        Locked = true;
      };
      PopupBlocking = {
        Allow = [ ];
        Default = true;
        Locked = true;
      };
      PostQuantumKeyAgreementEnabled = true;
      PrimaryPassword = false;
      PrintingEnabled = true;
      PromptForDownloadLocation = false;
      RequestedLocales = [ "en-US" ];
      SearchBar = "unified"; # alternative: "separate"
      SearchEngines.PreventInstalls = true;
      SearchSuggestEnabled = false;
      UserMessaging = {
        Locked = true;
        ExtensionRecommendations = true;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
      };
      UseSystemPrintDialog = true;

      # ---- PREFERENCES ----
      # Check about:config for options.
      Preferences = {
        "browser.contentblocking.category" = {
          Value = "strict";
          Status = "locked";
        };
        "browser.topsites.contile.enabled" = lock-false;
        "browser.translations.automaticallyPopup" = lock-false;
        "media.ffmpeg.vaapi.enabled" = lock-true;
        "full-screen-api.warning.timeout" = {
          Value = 500;
          Status = "locked";
        };
        "privacy.donottrackheader.enabled" = lock-true;
        "privacy.globalprivacycontrol.enabled" = lock-true;
      };
    };
  };
}
