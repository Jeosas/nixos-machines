{
  lib,
  namespace,
  inputs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt enabled;

  cfg = config.${namespace}.services.websites.portfolio;
in
{
  options.${namespace}.services.websites.portfolio = with lib.types; {
    enable = mkEnableOption "portfolio";
    domain = mkOpt str "" "website domain";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.domain != "";
        message = "domain must be provided";
      }
    ];

    ${namespace}.services.nginx = enabled;

    services.nginx.virtualHosts.${cfg.domain} = {
      enableACME = true;
      forceSSL = true;

      serverAliases = [ "www.${cfg.domain}" ];

      root = "${inputs.thewinterdev-website.packages.${config.nixpkgs.system}.default}/www/public";

      extraConfig = ''
        error_page 404 /404.html;
      '';
    };

    security.acme.certs.${cfg.domain} = {
      email = config.${namespace}.services.nginx.adminEmail;
    };
  };
}
