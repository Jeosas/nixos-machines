{ pkgs, ... }:
{
  extraPackages = with pkgs.elmPackages; [
    elm-format
  ];
  plugins = {
    lsp.servers.elmls = {
      enable = true;
    };
    conform-nvim.settings.formatters_by_ft = {
      elm = [
        "elm_format"
      ];
    };
  };
}
