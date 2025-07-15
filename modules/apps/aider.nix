{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.generators) toYAML;

  cfg = config.${namespace}.apps.aider;
in
{
  options.${namespace}.apps.aider = {
    enable = mkEnableOption "aider";
  };

  config = mkIf cfg.enable {
    ${namespace}.apps.ollama.enable = true;

    home-manager.users.${config.${namespace}.user.name} = {
      home = {
        packages = with pkgs; [
          aider-chat-full
        ];

        sessionVariables = {
          OLLAMA_API_BASE = "http://127.0.0.1:11434";
        };

        file = {
          ".aider.conf.yml" = {
            text = (toYAML { }) {
              model = "ollama_chat/gemma3n:e4b";
              dark-mode = true;
              analytics = false;
              analytics-disable = true;
            };
          };
        };
      };
    };
  };
}
