{pkgs, ...}: {
  extraPackages = with pkgs; [];

  plugins = {
    lsp.servers.LANG = {
      enable = true;
    };
    conform-nvim.settings.formatters_by_ft = {
      LANG = [];
    };
    lint.lintersByFt = {
      LANG = [];
    };
  };
}

