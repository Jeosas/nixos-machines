{ config, ... }:

{
  home = {
    sessionVariables = {
      SHELL = "${config.programs.zsh.package}/bin/zsh";
    };

    file.".bash_profile" = {
      text = /* bahs */ ''
        INIT_PROFILE=true exec ${config.programs.zsh.package}/bin/zsh
      '';
    };
  };

  programs.zsh.initExtraFirst = ''
    if [[ "''${INIT_PROFILE}" == "true" ]]; then
      . "$HOME/${config.programs.zsh.dotDir}/.zprofile"
    fi
  '';
}
