{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    sqlfluff
  ];

  plugins = {
    conform-nvim.settings.formatters_by_ft = {
      sql = [ "sqlfluff" ];
    };
    lint.lintersByFt = {
      sql = [ "sqlfluff" ];
    };
  };
}
