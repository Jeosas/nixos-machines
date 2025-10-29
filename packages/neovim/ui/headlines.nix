{ _, ... }:
{
  plugins.headlines = {
    enable = true;
    settings = {
      markdown = {
        headline_highlights = [
          "Headline1"
          "Headline2"
          "Headline3"
          "Headline4"
          "Headline5"
          "Headline6"
        ];
        bullets = [
          "#"
          "##"
          "###"
          "####"
          "#####"
          "######"
        ];
        codeblock_highlight = "CodeBlock";
        dash_highlight = "Dash";
        quote_highlight = "Quote";
      };
    };
  };
}
