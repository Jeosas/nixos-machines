{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [ macchina ];


  xdg.configFile = {
    "macchina/macchina.toml" = {
      text = /* toml */ ''
        theme = "nixos"
        long_kernel = true
        show = [
          "Host", 
          "Uptime",
          "Distribution",
          "Kernel",
          "OperatingSystem",
          "Packages",
          "WindowManager",
          "Resolution",
          "Shell",
          "ProcessorLoad",
          "Memory",
        ]
      '';
    };
    "macchina/themes/nixos.toml" = {
      text = /* toml */ ''
        separator = ""
        key_color = "Cyan"

        [palette]
        type = "Dark"
        glyph = " ⬤  "
        visible = true

        [bar]
        glyph = ""
        hide_delimiters = true
        visible = true

        [box]
        title = " Hello there "
        border = "rounded"
        visible = true

        [box.inner_margin]
        x = 2
        y = 1

        [custom_ascii]
        color = "Blue"
        path = "~/.config/macchina/nixos.ascii"
      '';
    };
    "macchina/nixos.ascii" = {
      text = /* ascii */''
                  ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖
                  ▜███▙       ▜███▙  ▟███▛
                   ▜███▙       ▜███▙▟███▛
                    ▜███▙       ▜██████▛
             ▟█████████████████▙ ▜████▛     ▟▙
            ▟███████████████████▙ ▜███▙    ▟██▙
                   ▄▄▄▄▖           ▜███▙  ▟███▛
                  ▟███▛             ▜██▛ ▟███▛
                 ▟███▛               ▜▛ ▟███▛
        ▟███████████▛                  ▟██████████▙
        ▜██████████▛                  ▟███████████▛
              ▟███▛ ▟▙               ▟███▛
             ▟███▛ ▟██▙             ▟███▛
            ▟███▛  ▜███▙           ▝▀▀▀▀
            ▜██▛    ▜███▙ ▜██████████████████▛
             ▜▛     ▟████▙ ▜████████████████▛
                   ▟██████▙       ▜███▙
                  ▟███▛▜███▙       ▜███▙
                 ▟███▛  ▜███▙       ▜███▙
                 ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘
      '';
    };
  };

  # add to zshrc
  programs.zsh.initExtra = ''
    macchina
  '';
}


