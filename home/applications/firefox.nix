{ inputs, config, pkgs, lib, ... }:

with lib;
let
  mkUserJs = { prefs ? { }, extraPrefs ? "" }: ''
    ${fileContents "${inputs.arkenfox-userjs}/user.js"} 

    ${concatStrings (mapAttrsToList (name: value: ''
      user_pref("${name}", ${builtins.toJSON value});
    '') prefs)}
  '';
in
{
  home.sessionVariables = mkIf config.wayland.windowManager.hyprland.enable {
    MOZ_ENABLE_WAYLAND = "1";
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    profiles.default = {
      isDefault = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        skip-redirect
        multi-account-containers
        behave
        bitwarden
        youtube-nonstop
        tridactyl
        kristofferhagen-nord-theme
        darkreader
      ];
      search = {
        default = "DuckDuckGo";
        privateDefault = "DuckDuckGo";
        force = true;
        order = [ "DuckDuckGo" ];
      };
      userChrome = /* css */ ''
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
          # Disable anoying features
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

          # Disable instals and auto updates
          "extensions.getAddons.showPane" = false;
          "app.update.auto" = false;
          "extensions.update.enabled" = false;

          # Fonts
          # "font.name.monospace.x-western" = "${fonts.mono.family}";
          # "font.name.sans-serif.x-western" = "${fonts.main.family}";
          # "font.name.serif.x-western" = "${fonts.serif.family}";
        };
      };
    };
  };
}

