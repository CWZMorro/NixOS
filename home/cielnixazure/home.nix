{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ../../features/niri.nix
    ../../features/helix.nix
    ../../features/herdr.nix
    ../../features/fastfetch.nix
  ];

  home.username = "cielnixazure";
  home.homeDirectory = "/home/cielnixazure";
  home.file.".face".source = ../../media/profile.png;

  home.packages = with pkgs; [
    # GUI Apps
    xwayland-satellite # needed for x11 apps
    discord
    spotify
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.morro-noctalia
    blender # Fate mod: weapon and staff models
    blockbench # Fate mod: Minecraft models

    # Text Editors / IDEs
    vscode
    code-cursor

    # Terminal emulator
    # kitty
    wezterm

    # Utilities
    fuzzel

    dunst
    pkgs.networkmanagerapplet
    grim # screenshot tool
    slurp # select area for ss
    wl-clipboard # clipboard manager
    brightnessctl # brightness control
    pavucontrol # gui volume control

    # CLI tools
    ripgrep
    fd
    unzip
    gcc
    lazygit
    gh # Fate mod: GitHub releases
    imagemagick # Fate mod: reference and render sheets
    ffmpeg # Fate mod: frames from reference videos
    bun # Fate mod: headless Blockbench MCP (bunx)
    xvfb-run # Fate mod: headless client game tests

    # CLI replacements
    bat
    eza
    fzf
    zoxide

    # Runtimes
    nodejs_24 # Fate mod: was nodejs_22; pi-mcp needs Node 23.6 or newer
    jdk17
    jdk25 # Fate mod: Minecraft 26.1.2 builds with Java 25
    python3

    # Theme
    nerd-fonts.jetbrains-mono
    adwaita-icon-theme
    shared-mime-info

    # rust
    cargo
    rustc

    # AI
    inputs.claude-code.packages.${pkgs.system}.default

  ];

  # Noctalia config
  xdg.configFile."noctalia/settings.json".source = ../../features/noctalia-settings.json;

  # Git config
  programs.git = {
    enable = true;
    settings = {
      user.name = "CWZ Morro"; # Fate mod: was "CielNixAzure"; matches the repos' author
      user.email = "cwzmorro@gmail.com";
      init.defaultBranch = "main";
    };
  };

  # Jujutsu config (Fate mod repos)
  programs.jujutsu = {
    enable = true;
    settings.user = {
      name = "CWZ Morro";
      email = "cwzmorro@gmail.com";
    };
  };

  # Shell config
  programs.fish = {
    enable = true;
    shellAliases = {
      # eza
      ls = "eza --color=always --icons=always";
      ll = "eza -lg --color=always --icons=always";
      lt = "eza --tree --color=always --icons=always";

      # git
      lg = "lazygit";

      # NixOS
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#CielNixAzure";
      conf = "nvim ~/nixos-config/hosts/local/configuration.nix";
      home = "nvim ~/nixos-config/home/cielnixazure/home.nix";
    };
    interactiveShellInit = ''
      # Fastfetch
      if set -q HERDR_PANE_ID # inside herdr
          fastfetch -c ~/.config/fastfetch/minimal.jsonc --logo-type none
      else
          fastfetch -c ~/.config/fastfetch/minimal.jsonc
      end

      # zoxide
      zoxide init fish --cmd cd | source

      # fuzzy finder
      fzf --fish | source
    '';
  };
  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $- == *i* ]]; then
        exec fish
      fi
    '';
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    shellWrapperName = "yy";
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  programs.home-manager.enable = true;
  # programs.waybar.enable = true;
  services.dunst.enable = true;

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "auto";
  };

  home.stateVersion = "24.11";
}
