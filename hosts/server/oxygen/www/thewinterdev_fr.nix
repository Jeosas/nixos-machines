{
  namespace,
  pkgs,
  inputs,
  config,
  ...
}:
let
  domain = "thewinterdev.fr";
in
{
  config = {
    ${namespace}.services.nginx.enable = true;

    services.nginx.virtualHosts.${domain} = {
      enableACME = true;
      forceSSL = true;

      serverAliases = [ "www.${domain}" ];

      root = "${
        inputs.thewinterdev-website.packages.${pkgs.stdenv.hostPlatform.system}.default
      }/www/public";

      extraConfig = ''
        error_page 404 /404.html;
      '';
    };

    security.acme.certs.${domain} = {
      email = config.${namespace}.services.nginx.adminEmail;
    };
  };
}
