{ config, ... }:

{
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/ssh"
      "/var/log"
      "/var/lib/bluetooth" # bluetooth devices
      "/etc/NetworkManager/system-connections" # wifi connections
      "/tmp" # needed for big nixos builds (thanks electron !)
    ];
    files = [
      "/etc/machine-id"
    ];
    users.jeosas = {
      directories = [
        ".setup" # nixps config
        "Images"
        "Documents"
        { directory = ".ssh"; mode = "0700"; } # ssh keys
        ".mozilla/firefox/default"
        "code"
        ".local/share/direnv/allow"
        ".cargo"
        ".config/Signal"
        ".logseq"
        ".config/Logseq"
        ".steam"
        ".heroic"
      ];
    };
  };
}
