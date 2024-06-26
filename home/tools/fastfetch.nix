{
  config,
  pkgs,
  ...
}: let
  config_file = "fastfetch.jsonc";
in {
  home.packages = with pkgs; [fastfetch];

  xdg.configFile.${config_file}.text =
    /*
    json
    */
    ''
      {
        "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
        "logo": {
          "source": "nix"
        },
        "display": {
          "separator": "",
          "percent": {
            "type": 3
          },
          "keyWidth": 25
        },
        "modules": [
          "title",
          "separator",
          "host",
          {
            "type": "cpu",
            "temp": true
          },
          {
            "type": "gpu",
            "temp": true
          },
          "break",
          "os",
          "kernel",
          "shell",
          "localip",
          "break",
          "cpuusage",
          "memory",
          "disk",
          "battery",
          "break",
          {
            "type": "colors",
            "symbol": "circle",
            "paddingLeft": 3
          }
        ]
      }
    '';

  # add to zshrc
  programs.zsh.initExtra = ''
    fastfetch -c ~/.config/${config_file}
  '';
}
