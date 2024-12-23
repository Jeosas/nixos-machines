{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    shfmt
    bash
    zsh
    shellcheck
  ];

  plugins = {
    lsp.servers.bashls = {
      enable = true;
    };
    conform-nvim.settings.formatters_by_ft = {
      sh = [ "shfmt" ];
      bash = [ "shfmt" ];
    };
    lint.lintersByFt = {
      sh = [
        "bash"
        "shellcheck"
      ];
      bash = [
        "bash"
        "shellcheck"
      ];
      zsh = [
        "zsh"
        "shellcheck"
      ];
    };
  };
}
