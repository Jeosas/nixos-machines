{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.apps.git;
in
{
  options.${namespace}.apps.git = with lib.types; {
    enable = mkEnableOption "git";
    userName = mkOpt str "Jeosas" "Git user name";
    userEmail = mkOpt str "jeanbaptiste@wintergerst.fr" "Git user email";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      git
    ];

    ${namespace} = {
      apps.stow.groups = [ "git" ];
    };
  };
}
