{
  lib,
  namespace,
  osConfig ? {},
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  inherit (osConfig.${namespace}.impermanence) systemDir;
  inherit (osConfig.${namespace}.user) name;

  userDir = "${systemDir}/home/${name}";

  cfg = config.${namespace}.impermanence;
in {
  options.${namespace}.impermanence = with types; {
    files =
      mkOpt (listOf str) [] "List of user files to persist";
    directories =
      mkOpt (listOf str) [] "List of user directories to persist";
  };

  config = mkIf (osConfig.${namespace}.impermanence.enable or false) {
    home.persistence.${userDir} = {
      allowOther = true;
      directories =
        [
          ".setup" # nixos config
          "Documents"
          "Pictures"
          "Music"
          "notes"
          "code"
          ".ssh"
        ]
        ++ cfg.directories;
      files = [] ++ cfg.files;
    };
  };
}
