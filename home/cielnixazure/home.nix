{ config, pkgs, ... }:

{
  home.username = "cielnixazure";
  home.homeDirectory = "/home/cielnixazure";
  
  home.packages = with pkgs; [
    # GUI Apps
    xwayland-satellite # needed for x11 apps
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
    pavucontrol # gui volume control
    

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
    spawn-at-startup "xwayland-satellite"
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

      // Audio controls
      XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "2%+"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "2%-"; }
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

  # Shell config
  programs.fish = {
    enable = true;
    shellAliases = {
      lg = "lazygit";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#CielNixAzure";
    };
  };
  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $- == *i* ]]; then
        exec fish
      fi
    '';
  };

  programs.home-manager.enable = true;
  programs.waybar.enable = true;
  services.dunst.enable = true;

  home.stateVersion = "24.11";
}
