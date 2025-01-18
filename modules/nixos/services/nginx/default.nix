{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.services.nginx;
in
{
  options.${namespace}.services.nginx = with lib.types; {
    enable = mkEnableOption "nginx";
    adminEmail = mkOpt str "admin+certs@thewinterdev.fr" "Letsencrypt admin email.";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    services.nginx = {
      enable = true;
      enableReload = true;
      clientMaxBodySize = "40M";
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
    };

    # Let's encrypt
    ## /var/lib/acme/.challenges must be writable by the ACME user
    ## and readable by the Nginx user.
    users.users.nginx.extraGroups = [ "acme" ];
    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.adminEmail;
    };
  };
}
