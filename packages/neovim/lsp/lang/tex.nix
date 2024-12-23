{ pkgs, ... }:
{
  extraPackages = with pkgs; [ tex-fmt ];

  plugins = {
    lsp.servers.texlab = {
      enable = true;
    };
    conform-nvim.settings.formatters_by_ft = {
      tex = [ "tex-fmt" ];
      plaintex = [ "tex-fmt" ];
    };
  };
}
