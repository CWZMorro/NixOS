{config, pkgs, inputs, ... }:

{
 home.username = "cielnixazure";
 home.homeDirectory = "/home/cielnixazure";

 home.packages = with pkgs; [
  firefox
  fuzzel
  waybar
  dunst
  kitty
 ];
 
 xdg.configFile."niri/config.kdl".text = ''
  input {
   keyboard {
    xkb { layout "us"; }
   }
  }
  binds {
   Mod+D { spawn "fuzzel"; }
   Mod+Return { spawn "kitty";  }
   Mod+W { close-window; }
  }
 '';

 programs.git = {
  enable = true;
  userName = "CielNixAzure";
  userEmail = "chungwinzun7765@gmail.com";

  extraConfig = {
   init.defaultBranch = "main";
   pull.rebase = false;
  };
 };

 programs.home-manager.enable = true;
 home.stateVersion = "24.05";
}
