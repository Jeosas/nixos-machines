{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.services.postgres;
in
{
  options.${namespace}.services.postgres = with lib.types; {
    package = mkOpt package pkgs.postgresql_18 "postgres package version to use";
    port = mkOpt int 5432 "postgres port";
    databases = mkOpt (listOf str) [ ] "postgres database to setup";
  };

  config = {
    services.postgresql = {
      enable = true;
      inherit (cfg) package;

      extensions = ps: with ps; [ ];

      enableTCPIP = false;

      settings = {
        inherit (cfg) port;
      };

      authentication = lib.mkForce ''
        #      database  user      address       auth-method ---
        local  all       postgres                peer
        host   shared    shared    127.0.0.1/32  scram-sha-256
        host   shared    shared    ::1/128       scram-sha-256
      '';

      ensureDatabases = [ "postgres" ] ++ cfg.databases;

      ensureUsers = [
        {
          name = "postgres";
          ensureDBOwnership = true;
          ensureClauses = {
            login = true;
            superuser = true;
            createrole = true;
            createdb = true;
          };
        }
      ]
      ++ map (name: {
        inherit name;
        ensureDBOwnership = true;
        ensureClauses = {
          login = true;
          superuser = false;
          createrole = false;
          createdb = false;
        };
      }) cfg.databases;
    };
  };
}
