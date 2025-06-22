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
    acceleration = mkOpt (enum [
      false
      "cuda"
    ]) false "gpu acceleration";
  };

  config =
    let
      ollamaHome = "/var/lib/ollama";
    in
    mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        (ollama.override { inherit (cfg) acceleration; })
      ];
      virtualisation.oci-containers = {
        backend = "docker";
        containers = {
          ollama = {
            image = "ollama/ollama";
            volumes = [ "${ollamaHome}:/root/.ollama" ];
            ports = [ "11434:11434" ];
            extraOptions = mkIf (cfg.acceleration == "cuda") [
              "--device=nvidia.com/gpu=all"
            ];
          };
        };
      };

      environment.persistence.main.directories = [ ollamaHome ];
    };
}
