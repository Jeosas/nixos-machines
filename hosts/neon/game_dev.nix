{ pkgs, ... }:

{
  home-manager.users.jeosas = {
    home.packages = with pkgs; [
      godot_4
    ];
  };

  environment.persistence."/persist" = {
    users.jeosas = {
      directories = [
        ".config/godot"
      ];
    };
  };
}
