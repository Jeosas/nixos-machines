{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.apps.stow;
in
{
  options.${namespace}.apps.stow = {
    enable = lib.mkEnableOption "Enable stow for default user";

    dotPath = lib.mkOption {
      type = lib.types.str;
      default = ".setup/dotfiles";
      description = "Path to the stow directory relative to the user home";
    };

    groups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of packages to stow";
    };
  };

  config =
    let
      userName = config.${namespace}.user.name;
      userHome = config.users.users.${userName}.home;
      resolvedDotPath = "${userHome}/${cfg.dotPath}";
      packageList = lib.concatStringsSep " " cfg.groups;

      stowRunScript = pkgs.writeShellScript "apply-dotfiles-${userName}.sh" ''
        set -eo pipefail

        if [ ! -d "${resolvedDotPath}" ]; then
          echo "stow-nix: Error: dotPath '${cfg.dotPath}' does not exist for user ${userName}" >&2
          exit 1
        fi

        echo "stow-nix: Applying stow for user ${userName}, packages: ${packageList}"
        ${pkgs.stow}/bin/stow -d ${resolvedDotPath} -t ${userHome} --no-folding -S ${packageList}

        echo "stow-nix: Stow completed successfully for ${userName}"

      '';
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        pkgs.stow
      ];

      systemd.user.services."stow-nix-${userName}" = {
        description = "Apply stow dotfiles for user ${userName}";
        serviceConfig = {
          Type = "oneshot";
          User = userName;
          Group = config.users.users.${userName}.group;
          ExecStart = "${stowRunScript}";
        };
        wantedBy = [ "default.target" ];
      };

      system.userActivationScripts."stow-nix-trigger-${userName}" = {
        deps = [ ];
        text = ''
          ${pkgs.systemd}/bin/systemctl start stow-nix-${userName}.service
        '';
      };
    };
}
