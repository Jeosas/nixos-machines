{ lib, pkgs, ... }:
let
  inherit (lib) genAttrs;
in
{
  extraPackages = with pkgs; [
    go
    gotools
    golines
    gofumpt
    golangci-lint
  ];

  plugins =
    let
      goFiletype = [
        "go"
        "gomod"
        "gowork"
        "gotmpl"
      ];
    in
    {
      lsp.servers.gopls = {
        enable = true;
      };
      conform-nvim.settings.formatters_by_ft = genAttrs goFiletype (_: [
        "goimports"
        "golines"
        "gofmt"
        "gofumpt"
      ]);
      lint = {
        lintersByFt = genAttrs goFiletype (_: [
          "golangcilint"
        ]);
      };
    };
}
