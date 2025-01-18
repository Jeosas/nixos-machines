{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.suites.base-workstation;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.suites.base-workstation = {
    enable = mkEnableOption "base workstation suite";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      user = enabled;
      theme = enabled;

      apps = {
        firefox = enabled;
        libreoffice = enabled;
        mullvad = enabled;
        transmission = enabled;
        xournal = enabled;
      };

      desktop.hyprland = enabled;

      hardware = {
        audio = enabled;
        graphics = enabled;
        network = {
          enable = true;
          enableNetworkManager = true;
        };
        ssd = enabled;
      };

      impermanence = enabled;

      security.doas = enabled;

      services.mullvad-vpn = enabled;

      system = {
        auto-mount = enabled;
        boot = enabled;
        fonts = enabled;
        locale = enabled;
        mtp = enabled;
        time = enabled;
      };

      home = {
        enable = true;
        extraConfig = {
          ${namespace} = {
            apps = {
              alacritty = enabled;
              kitty = enabled;
            };
            cli-apps = {
              btop = enabled;
              home-manager = enabled;
              neovim = enabled;
              termscp = enabled;
              yazi = enabled;
            };
            tools = {
              bat = enabled;
              choudai = enabled;
              git = enabled;
              ripgrep = enabled;
              ssh = enabled;
              starship = enabled;
              zsh = enabled;
              fastfetch = enabled;
            };
          };
        };
      };
    };
  };
}
