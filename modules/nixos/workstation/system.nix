{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib.${namespace}) mkOpt mkIf;

  cfg = config.${namespace}.workstation.system;
in
{
  options.${namespace}.workstation.system = with lib.types; {
    defaultLocale = mkOpt str "en_US.UTF-8" "Default locale for the system";
  };

  config = mkIf config.workstation.enable {
    # locale
    i18n.defaultLocale = cfg.defaultLocale;
    # ${namespace}.workstation.home.extraConfig = {
    #   home.language.base = cfg.defaultLocale;
    # };

    # time (ntp)
    time.timeZone = "Europe/Paris";
    services.ntp.enable = true;

    # fonts
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };
    environment.variables = {
      LOG_ICONS = "true"; # Enable icons in tooling since we have nerdfonts.
    };
    programs.dconf.enable = true; # Required for Home Manager's GTK settings to work
    fonts = {
      packages =
        with pkgs;
        with config.${namespace}.theme.fonts;
        [
          # Sain default for fallback
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif

          # Windaube fonts for compat
          corefonts
          vistafonts

          # Theme
          sans.package
          mono.package
          emoji.package
        ];
      fontconfig = {
        enable = true;
        useEmbeddedBitmaps = true;
        defaultFonts = with config.${namespace}.theme.fonts; {
          monospace = [ mono.name ];
          serif = [ sans.name ];
          sansSerif = [ sans.name ];
          emoji = [ emoji.name ];
        };
      };
    };

    # autoMount/usb
    services = {
      devmon.enable = true;
      udisks2.enable = true;
    };

    # autoMount/mtp
    environment.systemPackages = with pkgs; [ jmtpfs ];
  };
}
