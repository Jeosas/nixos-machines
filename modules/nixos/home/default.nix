{
  lib,
  namespace,
  config,
  inputs,
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
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.${namespace}.home = with lib.types; {
    enable = mkEnableOption "home";
    # extraConfig: limitation for setting lists in multiple files, fails to merge them.
    extraConfig = mkOpt (attrsOf anything) { } "Extra home manager config.";
  };

  config = mkIf cfg.enable {
    home-manager = {
      extraSpecialArgs = {
        inherit namespace inputs;
        lib = lib.extend (final: prev: inputs.home-manager.lib);
        osConfig = config;
      };

      useUserPackages = true;
      useGlobalPkgs = true;
    };

    home-manager.users.${username} =
      let
        hmModules = lib.${namespace}.getDefaultNixFilesRecursive ../../home;
      in
      mkMerge [
        { imports = hmModules; }
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

    ${namespace}.impermanence = {
      userDirectories = [
        ".setup" # nixos config
        "Documents"
        "Pictures"
        "Music"
        "notes"
        "code"
        ".ssh"
      ];
    };
  };
}
