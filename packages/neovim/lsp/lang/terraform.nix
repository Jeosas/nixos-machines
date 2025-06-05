{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    # Lint
    trivy
    tflint
    tflint-plugins.tflint-ruleset-google
  ];

  filetype = {
    pattern = {
      ".*/terragrunt%.hcl" = "hcl.terragrunt";
    };
  };

  plugins = {
    lsp.servers = {
      terraformls.enable = true;
    };

    conform-nvim.settings.formatters_by_ft =
      let
        tfFmt = [ "terraform_fmt" ];
      in
      {
        terraform = tfFmt;
        terraform-vars = tfFmt;
        "hcl.terragrunt" = [ "terragrunt_hclfmt" ];
      };

    lint.lintersByFt =
      let
        tfLint = [
          "tflint"
          "trivy"
        ];
      in
      {
        terraform = tfLint;
        terraform-vars = tfLint;
      };
  };
}
