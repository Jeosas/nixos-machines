{pkgs, ...}: {
  extraPackages = with pkgs; [nixfmt-rfc-style statix];

  plugins = {
    lsp.servers.nil_ls = {
      enable = true;
      settings = {
        formatting.command = ["nixfmt"];
      };
    };
    conform-nvim.settings.formatters_by_ft = {
      nix = ["nixfmt"];
    };
    lint.lintersByFt = {
      nix = ["statix"];
    };
  };
}
