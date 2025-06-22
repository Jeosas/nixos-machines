{ pkgs, namespace, ... }:
{
  plugins = {
    lsp.servers.rust_analyzer = {
      enable = true;

      # use devShell env
      installRustc = false;
      installCargo = false;
      installRustfmt = false;
    };
    conform-nvim.settings = {
      formatters = {
        maudfmt = {
          command = "${pkgs.${namespace}.maudfmt}/bin/maudfmt";
          args = [ "-s" ];
        };
      };
      formatters_by_ft = {
        rust = [
          "rustfmt"
          "maudfmt"
        ];
      };
    };
  };
}
