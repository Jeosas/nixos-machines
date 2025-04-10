{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    yamlfmt
    yamllint
    actionlint
    shellcheck
  ];

  filetype = {
    pattern = {
      ".*/.github/workflows/.*%.yml" = "yaml.ghaction";
    };
  };

  plugins = {
    lsp.servers.yamlls = {
      enable = true;
    };
    conform-nvim.settings.formatters_by_ft = {
      yaml = [ "yamlfmt" ];
    };
    lint.lintersByFt = {
      yaml = [ "yamllint" ];
      "yaml.ghaction" = [ "actionlint" ];
    };

    schemastore = {
      enable = true;
      yaml = {
        enable = true;
        settings = {
          ignore = [ ];
          # extra = [
          #   {
          #     description = "My other custom JSON schema";
          #     fileMatch = ["bar.json" ".baar.json"];
          #     name = "bar.json";
          #     url = "https://example.com/schema/bar.json";
          #   }
          # ];
        };
      };
    };
  };
}
