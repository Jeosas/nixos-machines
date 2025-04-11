{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace};
let
  mkUserJs =
    {
      prefs ? { },
      extraPrefs ? "",
    }:
    ''
      ${fileContents "${inputs.arkenfox-userjs}/user.js"}

      ${concatStrings (
        mapAttrsToList (name: value: ''
          user_pref("${name}", ${builtins.toJSON value});
        '') prefs
      )}
    '';

  cfg = config.${namespace}.apps.firefox;
in
{
  options.${namespace}.apps.firefox = {
    enable = mkEnableOption "Firefox";
    enableWaylandSupport = mkOpt types.bool true "Enable wayland support.";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = mkIf cfg.enableWaylandSupport { MOZ_ENABLE_WAYLAND = "1"; };

    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
      profiles.default = {
        isDefault = true;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          behave
          bitwarden
          kristofferhagen-nord-theme
        ];
        search = {
          default = "DuckDuckGo";
          privateDefault = "DuckDuckGo";
          force = true;
          order = [ "DuckDuckGo" ];
        };
        userChrome =
          # css
          ''
            /*
            This repo https://github.com/Timvde/UserChrome-Tweaks contains nice snippets.
            */

            /* Remove 'Sync' ad from App Menu. */
            #appMenu-fxa-status2,
            #appMenu-fxa-status2 + toolbarseparator {
              display: none !important;
            }
          '';
        extraConfig = mkUserJs {
          prefs = {
            # Disable annoying features
            "browser.bookmarks.restore_default_bookmarks" = false;
            "signon.rememberSignons" = false;
            "extensions.pocket.enabled" = false;
            "browser.quitShortcut.disabled" = true;

            # UI
            "browser.compactmode.show" = true;
            "browser.uidensity" = 1;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            ## kristofferhagen-nord-theme
            "extensions.activeThemeID" = "{e410fec2-1cbd-4098-9944-e21e708418af}";

            # Disable installs and auto updates
            "extensions.getAddons.showPane" = false;
            "app.update.auto" = false;
            "extensions.update.enabled" = false;

            # --- Arkenfox overrides ---
            # letterboxing
            "privacy.resistFingerprinting.letterboxing" = false;
            # # webRTC
            # "media.peerconnection.enabled" = true;
            # webGL
            "webgl.disabled" = false;
          };
        };
      };
    };
  };
}
