{ config, pkgs, ... }:

{
  home.username = "cielnixazure";
  home.homeDirectory = "/home/cielnixazure";
  
  home.packages = with pkgs; [
    kitty
    fuzzel
    waybar
    dunst
    pkgs.networkmanagerapplet
  ];
  
  # Niri config
  xdg.configFile."niri/config.kdl".text = ''
    spawn-at-startup "waybar"
    spawn-at-startup "dunst"
    spawn-at-startup "nm-applet"
    input {
      keyboard {
        xkb { layout "us"; }
      }
    }
    binds {
      Mod+D { spawn "fuzzel"; }
      Mod+Return { spawn "kitty"; }
      Mod+W { close-window; }
    }
  '';

  # Git config
  programs.git = {
    enable = true;
    userName = "CielNixAzure";
    userEmail = "chungwinzun7765@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.home-manager.enable = true;
  programs.waybar.enable = true;
  services.dunst.enable = true;
  services.ssh-agent.enable = true;

  home.stateVersion = "24.11";
}
