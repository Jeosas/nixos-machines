{ pkgs, ... }:
{
  extraPackages = with pkgs; [ prettierd ];

  plugins = {
    lsp.servers.marksman = {
      enable = true;
    };
    conform-nvim.settings.formatters_by_ft = {
      markdown = [ "prettierd" ];
      "markdown.mdx" = [ "prettierd" ];
    };
  };
}
