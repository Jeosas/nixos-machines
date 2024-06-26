# Common nginx config
{config, ...}: {
  networking.firewall.allowedTCPPorts = [80 443];
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
  users.users.nginx.extraGroups = ["acme"];
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin+certs@thewinterdev.fr";
  };
}
