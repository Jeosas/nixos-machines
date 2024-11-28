{
  lib,
  namespace,
  options,
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.home;
in {
  options.${namespace}.home = with types; {
    extraConfig =
      mkOpt (attrsOf anything) {} "A config set to be passed directly to home-manager.";
    configFile =
      mkOpt (attrsOf str) {}
      "A set of files to be managed by home-manager's `xdg.configFile`.";
    file =
      mkOpt (attrsOf str) {}
      "A set of files to be managed by home-manager's `home.file`.";
  };

  config = {
    home-manager = {
      extraSpecialArgs = {
        osConfig = config;
      };

      useUserPackages = true;
      useGlobalPkgs = true;
    };

    home-manager.users.${config.${namespace}.user.name} = {
      home = {
        stateVersion = config.system.stateVersion;
        file = mkAliasDefinitions options.${namespace}.home.file;
      };

      xdg = {
        enable = true;
        configFile = mkAliasDefinitions options.${namespace}.home.configFile;
      };
    };
  };
}
