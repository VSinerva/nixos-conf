{ config, pkgs, ... }:
{
  programs.firefox = {
    preferences = {
      "media.ffmpeg.vaapi.enabled" = true;
    };
    enable = true;
    preferencesStatus = "locked";
    policies = {
      ExtensionSettings = {
        "*".installation_mode = "blocked";
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
