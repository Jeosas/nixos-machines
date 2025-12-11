{
  lib,
  config,
  namespace,
  inputs,
  ...
}:
let
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.sops;
in
{
  imports = [
    inputs.sops.nixosModules.sops
  ];

  options.${namespace}.sops = with lib.types; {
    secretFile = mkOpt path "" "this host's secret file path";
  };

  config = {
    sops = {
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      defaultSopsFile = cfg.secretFile;
    };
  };
}
