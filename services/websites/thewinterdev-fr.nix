{ config, inputs, ... }:

let
  domain = "thewinterdev.fr";
in
{
  services.nginx.virtualHosts.${domain} = {
    enableACME = true;
    forceSSL = true;

    serverAliases = [ "www.${domain}" ];

    root ="${inputs.thewinterdev-website.packages.${config.nixpkgs.system}.default}/www/public";

    extraConfig = ''
      error_page 404 /404.html;
    '';
  };

  security.acme.certs.${domain} = {
    email = "admin+certs@thewinterdev.fr";
  };
}
