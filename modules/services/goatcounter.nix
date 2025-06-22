{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.services.goatcounter;

  domain = "analytics.innovlens.fr";
  dataDir = "/var/lib/goatcounter";
  port = 8081;

  user = "goatcounter";
  group = "goatcounter";
in
{
  options.${namespace}.services.goatcounter = {
    enable = mkEnableOption "goatcounter";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      services.nginx.enable = true;
    };
    environment.persistence.main.directories = [
      {
        inherit user group;
        directory = dataDir;
        mode = "u=rwx,g=,o=";
      }
    ];

    users = {
      groups.${group} = { };
      users.${user} = {
        inherit group;
        isSystemUser = true;
      };
    };

    systemd = {
      tmpfiles.rules = [
        "d ${dataDir} 700 ${user} ${group}"
      ];

      services.goatcounter = {
        description = "Easy web analytics. No tracking of personal data.";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = user;
          Group = group;

          Restart = "always";

          ExecStart = lib.escapeShellArgs [
            "${pkgs.goatcounter}/bin/goatcounter"
            "serve"
            "-listen"
            "127.0.0.1:${toString port}"
            "-tls"
            "http"
            "-db"
            "sqlite+${dataDir}/goatcounter.sqlite3"
            "-automigrate"
          ];

          ProtectSystem = "full";
          ReadWritePaths = "${dataDir}";
          ReadOnlyPaths = "${pkgs.goatcounter}";

          # hardening
          NoNewPrivileges = true;
          LockPersonality = true;
          SystemCallFilter = "@system-service";
          PrivateTmp = true;
          ProtectHome = true;
        };
      };
    };

    services.nginx.virtualHosts.${domain} = {
      enableACME = true;
      forceSSL = true;

      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
        };
      };
    };

    security.acme.certs.${domain} = {
      email = config.${namespace}.services.nginx.adminEmail;
    };
  };
}
