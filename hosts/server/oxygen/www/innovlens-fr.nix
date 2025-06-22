{
  pkgs,
  namespace,
  inputs,
  config,
  ...
}:
let
  domain = "innovlens.fr";
  dataDir = "/var/lib/innovlens";
  port = 8082;

  user = "www-innovlens";
  group = "www-innovlens";
in
{
  config = {
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

      services.innovlens-web-app = {
        description = "InnovLens web app";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          User = user;
          Group = group;

          Restart = "always";

          ExecStart = "${inputs.innovlens.packages.${pkgs.system}.http}/bin/innovlens";

          ProtectSystem = "full";
          ReadWritePaths = "${dataDir}";
          ReadOnlyPaths = "${inputs.innovlens.packages.${pkgs.system}.http}";

          # hardening
          NoNewPrivileges = true;
          LockPersonality = true;
          SystemCallFilter = "@system-service";
          PrivateTmp = true;
          ProtectHome = true;
        };
        environment = {
          INNOVLENS_ENV = "prod";
          INNOVLENS_PORT = toString port;
          INNOVLENS_DB_FILE = "sqlite:${dataDir}/innovlens.sqlite3";
        };
      };
    };

    services.nginx.virtualHosts.${domain} = {
      enableACME = true;
      forceSSL = true;

      serverAliases = [ "www.${domain}" ];

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
