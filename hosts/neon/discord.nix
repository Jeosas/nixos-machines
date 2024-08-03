{pkgs, ...}: {
  environment.persistence."/persist" = {
    users.jeosas = {
      directories = [
        ".config/discord"
      ];
    };
  };

  home-manager.users.jeosas = {
    home.packages = with pkgs; [discord];
  };
}
