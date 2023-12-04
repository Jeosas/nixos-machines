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
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    profiles.default = {
      isDefault = true;
      containers = {
        Google = {
          color = "red";
          icon = "chill";
          id = 1;
        };
        Music = {
          color = "green";
          icon = "circle";
          id = 2;
        };
      };
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

        /* Move Tab bar to the right. */

        /* Move toolbox to the bottom. */

        body {
        	flex-direction: column-reverse !important;
        }

        #urlbar {
          top: unset !important;
          bottom: calc((var(--urlbar-toolbar-height) - var(--urlbar-height)) / 2) !important;
          box-shadow: none !important;
          display: flex !important;
          flex-direction: column !important;
        }

        #urlbar-input-container {
          order: 2;
        }

        #urlbar > .urlbarView {
          order: 1;
          border-bottom: 1px solid #666;
        }

        toolbox[inFullscreen=true] { 
          display: none;
        }


        /* Remove 'Sync' ad from App Menu. */

        #appMenu-fxa-status2, 
        #appMenu-fxa-status2 + toolbarseparator {
          display: none !important;
        }


        /* Inverse App Menu. */

        .panel-subview-body {
          display: flex !important;
          flex-direction: column-reverse !important;
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

