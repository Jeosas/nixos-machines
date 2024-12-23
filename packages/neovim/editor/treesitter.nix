{ ... }:
{
  plugins.treesitter = {
    enable = true;
    languageRegister = {
      # parser = ["ft"];
    };

    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
  };
}
