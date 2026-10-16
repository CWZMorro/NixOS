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
    ../../features/zellij.nix
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
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.zellij-load

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

    # CLI replacements
    bat
    eza
    fzf
    zoxide

    # Runtimes
    nodejs_22
    jdk17
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
      user.name = "CielNixAzure";
      user.email = "cwzmorro@gmail.com";
      init.defaultBranch = "main";
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
      if set -q ZELLIJ
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
