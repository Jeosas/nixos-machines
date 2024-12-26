{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkMerge;
  inherit (lib.${namespace}) mkOpt;

  username = config.${namespace}.user.name;
  homeDirectory = "/home/${username}";

  cfg = config.${namespace}.home;
in
{
  options.${namespace}.home = with lib.types; {
    enable = mkEnableOption "home";
    # extraConfig: limitation for setting lists in multiple files, fails to merge them.
    extraConfig = mkOpt (attrsOf anything) { } "Extra home manager config.";
  };

  config = mkIf cfg.enable {
    home-manager = {
      extraSpecialArgs = {
        osConfig = config;
      };

      useUserPackages = true;
      useGlobalPkgs = true;
    };

    home-manager.users.${username} = mkMerge [
      {
        home = {
          inherit (config.system) stateVersion;
          inherit username homeDirectory;
        };

        xdg = {
          enable = true;
        };

        systemd.user = {
          enable = true;
          startServices = "sd-switch";
        };
      }
      cfg.extraConfig
    ];
  };
}
