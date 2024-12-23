{...}: {
  plugins.dressing = {
    enable = true;
    settings = {
      input = {
        relative = "editor";
        border = "single";
        win_options = {
          winhighlight = "FloatBorder:,NormalFloat:";
        };
      };
      select = {
        backend = ["telescope" "builtin"];
      };
    };
  };
}
