{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt mkOpt';
  cfg = config.${namespace}.services.ollama;
in
{
  options.${namespace}.services.ollama = with lib.types; {
    enable = mkEnableOption "ollama";
    port = mkOpt' int 11434;
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
            ports = [ "${toString cfg.port}:11434" ];
            extraOptions = mkIf (cfg.acceleration == "cuda") [
              "--device=nvidia.com/gpu=all"
            ];
          };
        };
      };

      ${namespace}.impermanence = {
        directories = [ ollamaHome ];
      };
    };
}
