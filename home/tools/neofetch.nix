{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ neofetch ];


  xdg.configFile."neofetch/config.conf" = {
    text = /* bash */ ''
      print_info() {
          prin "\n"
          prin "\n"
          prin "\n"
          info "\n \n \n \n \n \n \n \n USER" title
          prin "┌───────────────────────────────┐"
          info " ​ ​ OS" distro
          info " ​ ​ Kernel" kernel
          info " ​ ​ Uptime" uptime
          info " ​ ​ Shell" shell
          info " ​ ​ Memory" memory
          info " ​ ​ Battery" battery
          prin "└───────────────────────────────┘"

          prin "\n"
          prin "\n \n \n \n \n \n \n \n ''${cl0}⬤  ''${cl7}⬤  ''${cl6}⬤  ''${cl5}⬤  ''${cl4}⬤  ''${cl3}⬤  ''${cl2}⬤  ''${cl1}⬤"
      }

      reset="\033[0m"
      red="\033[1;31m"
      green="\033[1;32m"
      yellow="\033[1;33m"
      blue="\033[1;34m"
      magenta="\033[1;35m"
      cyan="\033[1;36m"
      white="\033[1;37m"

      cl0="''${reset}"
      cl1="''${red}"
      cl2="''${green}"
      cl3="''${yellow}"
      cl4="''${blue}"
      cl5="''${magenta}"
      cl6="''${cyan}"
      cl7="''${white}"
    '';
  };

  # add to zshrc
  programs.zsh.initExtra = ''
    neofetch
  '';
}
