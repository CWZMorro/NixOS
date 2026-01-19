{ config, pkgs, ... }:

{
  home.username = "cielnixazure";
  home.homeDirectory = "/home/cielnixazure";
  
  home.packages = with pkgs; [
    # GUI Apps
    discord
    spotify

    # Terminal emulator 
    kitty

    # Utilities
    fuzzel
    waybar
    dunst
    pkgs.networkmanagerapplet
    grim # screenshot tool
    slurp # select area for ss
    wl-clipboard # clipboard manager
    brightnessctl # brightness control
    

    # Lazyvim
    neovim
    ripgrep
    fd
    unzip
    gcc
    lazygit

    # Fonts
    nerd-fonts.jetbrains-mono
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
    userEmail = "cwzmorro@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.home-manager.enable = true;
  programs.waybar.enable = true;
  services.dunst.enable = true;

  home.stateVersion = "24.11";
}
