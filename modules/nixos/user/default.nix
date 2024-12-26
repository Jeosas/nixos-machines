{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt enabled;

  defaultPasswordFile = "${config.${namespace}.impermanence.systemDir}/${cfg.name}-password";

  cfg = config.${namespace}.user;
in
{
  options.${namespace}.user = with lib.types; {
    enable = mkEnableOption "user";
    name = mkOpt str "jeosas" "The name to use for the user account.";
    hashedPasswordFile = mkOpt str defaultPasswordFile "The file path to the hashed user password.";
    extraGroups = mkOpt (listOf str) [ ] "A list of groups for the user to be assigned to.";
  };

  config = mkIf cfg.enable {
    # Configuring for the default shell I want to use.
    programs.zsh = enabled;

    users = mkIf cfg.enable {
      mutableUsers = false;

      users.${cfg.name} = {
        inherit (cfg) name hashedPasswordFile;

        home = "/home/${cfg.name}";
        group = "users";
        shell = pkgs.zsh;

        extraGroups = [ "wheel" ] ++ cfg.extraGroups;

        # If false, user is treated as a system user.
        isNormalUser = true;
      };
    };
  };
}
