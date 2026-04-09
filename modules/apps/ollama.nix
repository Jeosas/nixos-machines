{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.apps.ollama;
in
{
  options.${namespace}.apps.ollama = with lib.types; {
    enable = mkEnableOption "ollama";
    package = mkOpt package "ollama package";
    acceleration = mkOpt (enum [
      false
      "cuda"
    ]) false "gpu acceleration";
  };

  config = mkIf cfg.enable {
    services.ollama = {
      inherit (cfg) enable;
      package =
        if cfg.acceleration == "cuda" then pkgs.unstable.ollama-cuda else pkgs.unstable.ollama-cpu;
      user = "ollama";
      group = "ollama";
      home = "/var/lib/private/ollama";
    };

    environment.persistence.main.directories = [
      {
        directory = config.services.ollama.home;
        inherit (config.services.ollama) user group;
        mode = "700";
      }
      {
        directory = config.services.ollama.models;
        inherit (config.services.ollama) user group;
        mode = "700";
      }
    ];
  };
}
