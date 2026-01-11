{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    optionalAttrs
    ;
  inherit (lib.${namespace}) mkOpt;
  inherit (lib.${namespace}.vars) dnsRecords;

  cfg = config.${namespace}.services.unbound;

  makeALocalzone = { domain, ... }: ''"${domain}" transparent'';
  makeALocaldata = { domain, ipv4 }: ''"${domain}. IN A ${ipv4}"''; # leaving 1h of TTL since local is fast
in
{
  options.${namespace}.services.unbound = with lib.types; {
    enable = mkEnableOption "unbound";
    openToNetwork = mkOpt bool false "open dns to network. if false, only localhost can call unbound";
    port = mkOpt int 53 "dns port";
    useRecursiveDNS = mkOpt bool false "use recursive DNS";
    localControlSocketPath =
      mkOpt str "/var/run/unbound/unbound.sock"
        "path to the local control socket";
  };

  config = mkIf cfg.enable {
    services.unbound = {
      enable = true;
      enableRootTrustAnchor = cfg.useRecursiveDNS;
      inherit (cfg) localControlSocketPath;
      settings = {
        server = {
          logfile = "${config.services.unbound.stateDir}/logfile";
          verbosity = 2;
          interface = mkIf cfg.openToNetwork [ "0.0.0.0" ];
          inherit (cfg) port;
          access-control = [
            "0.0.0.0/0 refuse"
            "127.0.0.0/8 allow"
            "192.168.0.0/16 allow"
            "172.16.0.0/12 allow"
            "10.0.0.0/8 allow"
            "::0/0 refuse"
            "::1/128 allow"
          ];

          hide-version = true;
          hide-identity = true;
          harden-glue = true;
          harden-dnssec-stripped = true;
          use-caps-for-id = false;
          edns-buffer-size = 1232;
          aggressive-nsec = true;
          qname-minimisation = true;

          auto-trust-anchor-file = "${config.services.unbound.stateDir}/root.key";

          do-ip4 = true;
          do-ip6 = true;
          prefer-ip4 = true;

          prefetch = true;
          cache-min-ttl = 3600;
          cache-max-ttl = 86400;

          extended-statistics = true;

          num-threads = 1;

          # Local records
          domain-insecure = [ ''"lan"'' ];
          local-zone = map makeALocalzone dnsRecords.A ++ [ ''"lan." static'' ];
          local-data = map makeALocaldata dnsRecords.A;
        }
        // optionalAttrs cfg.useRecursiveDNS {
          root-hints = "${pkgs.dns-root-data}/root.hints";
        };

        forward-zone = mkIf (!cfg.useRecursiveDNS) [
          # quad9
          {
            name = ".";
            forward-tls-upstream = true; # Protected DNS
            forward-first = false;
            forward-addr = [
              "9.9.9.9#dns.quad9.net"
              "149.112.112.112#dns.quad9.net"
            ];
          }
        ];
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openToNetwork [ cfg.port ];
    networking.firewall.allowedUDPPorts = mkIf cfg.openToNetwork [ cfg.port ];
  };
}
