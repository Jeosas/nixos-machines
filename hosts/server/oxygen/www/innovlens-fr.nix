{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.services.innovlens-http;

  database = "shared";
in
{
  options.${namespace}.services.innovlens-http = with lib.types; {
    domain = mkOpt str "innovlens.fr" "http domain";
    dataDir = mkOpt str "/var/lib/innovlens" "data directory for the http server";
    port = mkOpt int 8082 "server http port";
    useTls = mkOpt bool true "use TLS";
    acmeAdminEmail = mkOpt str "jb.wintergerst@innovlens.fr" "admin email for certificates";

    user = mkOpt str "www-innovlens" "http server user";
    group = mkOpt str "www-innovlens" "http server user group";
  };

  config = {
    ${namespace} = {
      services.postgres = {
        databases = [ database ];
      };
    };

    sops.secrets =
      let
        secretChmod = {
          mode = "0440";
          owner = cfg.user;
          inherit (cfg) group;

          restartUnits = [ "innovlens-web-app.service" ];
        };

      in
      {
        "innovlens_web_cookie_key" = secretChmod;
        "innovlens_web_jwt_key" = secretChmod;
        "innovlens_web_postgres_password" = secretChmod;
      };

    users = {
      groups.${cfg.group} = { };
      users.${cfg.user} = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    systemd.services = {
      innovlens-web-app = {
        description = "InnovLens web app";
        requires = [ "innovlens-pg-migration-shared.service" ];
        after = [
          "network.target"
          "innovlens-pg-migration-shared.service"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;

          Restart = "always";

          ExecStart = "${pkgs.innovlens.innovlens-http}/bin/innovlens-http";

          ProtectSystem = "full";
          ReadOnlyPaths = "${pkgs.innovlens.innovlens-http}";

          # hardening
          NoNewPrivileges = true;
          LockPersonality = true;
          SystemCallFilter = "@system-service";
          PrivateTmp = true;
          ProtectHome = true;

          EnvironmentFile = [
            config.sops.secrets."innovlens_web_cookie_key".path
            config.sops.secrets."innovlens_web_jwt_key".path
            config.sops.secrets."innovlens_web_postgres_password".path
          ];
        };

        environment =
          let
            base_url = if cfg.useTls then "https://${cfg.domain}" else "http://${cfg.domain}";
          in
          {
            INNOVLENS_FF_FORCE_ALL = "false";

            INNOVLENS_LOGGING_LEVEL = "INFO";

            INNOVLENS_HTTP_ENV = "prod";
            INNOVLENS_HTTP_PORT = toString cfg.port;
            INNOVLENS_HTTP_ORIGINS = base_url;
            INNOVLENS_HTTP_BASE_URL = base_url;

            INNOVLENS_PG_HOST = "localhost";
            INNOVLENS_PG_PORT = toString config.${namespace}.services.postgres.port;
            INNOVLENS_PG_USER = database;
            INNOVLENS_PG_DB_NAME = database;
            INNOVLENS_PG_MIN_IDLE_CONN = "1";
            INNOVLENS_PG_MAX_CONN = "3";

            # vvv  all values below aren't used and are bogus  vvv
            # vvv they MUST be changed when deploying the beta vvv
            INNOVLENS_SMTP_HOST = "localhost";
            INNOVLENS_SMTP_PORT = "2525";
            INNOVLENS_SMTP_USERNAME = "smtp_dev";
            INNOVLENS_SMTP_PASSWORD = "smtp_dev";
          };
      };

      innovlens-pg-migration-shared = {
        description = "InnovLens Postgres shared migration";

        requires = [
          "postgresql.service"
          "postgresql-setup.service"
        ];
        after = [ "postgresql-setup.service" ];

        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          Type = "oneshot";
          RemainAfterExit = true;

          EnvironmentFile = [
            config.sops.secrets."innovlens_web_postgres_password".path
          ];
        };

        path = [
          config.${namespace}.services.postgres.package
          pkgs.innovlens.innovlens-infra-cli
        ];

        environment = {
          INNOVLENS_PG_HOST = "localhost";
          INNOVLENS_PG_PORT = toString config.${namespace}.services.postgres.port;
          INNOVLENS_PG_USER = database;
        };

        # Wait for PostgreSQL to be ready to accept connections.
        script = ''
          check-connection() {
            pg_isready -d shared
          }
          while ! check-connection 2> /dev/null; do
              if ! systemctl is-active --quiet postgresql.service; then exit 1; fi
              sleep 0.1
          done

          innovlens-infra-cli pg-migrate shared
        '';
      };
    };

    services.nginx.virtualHosts.${cfg.domain} = {
      enableACME = cfg.useTls;
      forceSSL = cfg.useTls;

      serverAliases = [ "www.${cfg.domain}" ];

      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
        };
      };
    };

    security.acme.certs.${cfg.domain} = mkIf cfg.useTls {
      email = cfg.acmeAdminEmail;
      # extraDomainNames = [ "www.${cfg.domain}" ];
    };
  };
}
