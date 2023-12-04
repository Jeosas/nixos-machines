{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      format = ''
        $nix_shell$container$git_branch$aws$python$rust
        $directory$battery$character'';

      right_format = ''$status$sudo$username[@](white)$hostname$time'';

      directory = {
        format = "[$path ]($style)";
        truncation_length = 4;
        truncation_symbol = "_/";
      };

      battery = {
        format = "[$symbol]($style)";
        display = [
          { threshold = 30; style = "yellow"; }
          { threshold = 10; style = "red"; }
        ];
      };

      time = {
        disabled = false;
        format = "[ $time](white)";
        time_format = "%R";
        utc_time_offset = "+1";
      };

      username = {
        show_always = true;
        format = "[ $user]($style)";
        style_user = "white";
        style_root = "red";
      };

      hostname = {
        format = "[$hostname](white)";
        trim_at = ".";
        ssh_only = false;
      };

      sudo.format = "[󱑷](bold yellow)";
    };
  };
}
