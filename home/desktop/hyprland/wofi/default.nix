{ config, pkgs, ... }:

{
  programs.wofi = {
    enable = true;
    settings = {
      insensitve = true;
      matching = "fuzzy";
      hide_scroll = true;
      term = "${pkgs.alacritty}/bin/alacritty";
    };
    style = with config.theme.colors; ''
      * {
        background-color: ${background};
        color: ${foreground};
      }
      #window { 
        border: solid 2px;
        border-color: ${color2};
        border-radius: 8px;
      }
      #outer-box {
        padding: 24px;
      }
      #input {
        margin: 8px;
        padding: 8px;
        border-color: ${color2};
      }
      input:focus, 
      textarea:focus, 
      #input,
      #input *,
      #input:focus, 
      #input *:focus {
        border-color: ${color2};
      }
      #scroll {
        padding: 8px;
        border: solid 2px;
        border-color: ${foreground};
        border-radius: 8px;
      }
      .entry {
        padding: 8px;
      }
      #entry:selected,
      #entry:selected *{
        border-radius: 8px;
        background-color: ${foreground};
        opacity: 0.7;
      }
      #entry:selected label {
        color: ${color0};
      }
    '';
  };
}

