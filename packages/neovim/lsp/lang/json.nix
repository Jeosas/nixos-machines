{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    jq
    python3
  ];

  plugins = {
    lsp.servers.jsonls = {
      enable = true;
    };
    conform-nvim.settings.formatters_by_ft = {
      json = [ "jq" ];
    };
    lint.lintersByFt = {
      json = [ "json_tool" ];
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
