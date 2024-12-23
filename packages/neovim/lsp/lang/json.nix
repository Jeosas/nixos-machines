{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    jq
    nodePackages.jsonlint
  ];

  plugins = {
    lsp.servers.jsonls = {
      enable = true;
    };
    conform-nvim.settings.formatters_by_ft = {
      json = [ "jq" ];
    };
    lint.lintersByFt = {
      json = [ "jsonlint" ];
    };

    schemastore = {
      enable = true;
      json = {
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
