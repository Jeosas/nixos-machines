{ pkgs, ... }: {
  extraPackages = with pkgs; [
    tinymist
    typstyle
  ];

  plugins = {
    lsp.servers.tinymist = {
      enable = true;
    };
    typst-preview.enable = true;
    conform-nvim.settings.formatters_by_ft = {
      typst = [ "typstyle" ];
    };
  };
}
