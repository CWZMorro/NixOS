{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ../../features/niri.nix
    ../../features/herdr.nix
    ../../features/fastfetch.nix
    ../../features/fish.nix
    inputs.omp.homeManagerModules.default
  ];

  home.username = "cielnixazure";
  home.homeDirectory = "/home/cielnixazure";
  home.file.".face".source = ../../media/profile.png;
  home.sessionVariables.EDITOR = "nvim"; # overrides NixOS's default EDITOR=nano

  home.packages = with pkgs; [
    # GUI Apps
    xwayland-satellite # needed for x11 apps
    vesktop
    # Run natively on Wayland so xwayland-satellite doesn't draw a title bar
    (symlinkJoin {
      name = "spotify";
      paths = [ spotify ];
      nativeBuildInputs = [ makeWrapper ];
      postBuild = "wrapProgram $out/bin/spotify --set NIXOS_OZONE_WL 1";
    })
    modrinth-app
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.morro-noctalia
    blender
    blockbench
    tigervnc
    osu-lazer-bin
    chromium

    # Text Editors / IDEs
    vscode
    code-cursor
    jetbrains.idea
    neovim

    # Terminal emulator
    # kitty

    # Utilities
    fuzzel
    yt-dlp

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
    gh
    imagemagick
    ffmpeg
    bun
    xvfb-run
    _7zz-rar

    # file viewer
    mpv # video
    imv # image 

    # Fun CLI tools
    cbonsai
    cmatrix
    cava

    # CLI replacements
    bat
    eza
    fzf
    zoxide
    (btop.override { cudaSupport = true; })

    # Runtimes
    nodejs_24
    jdk25
    python3

    # Package managers
    pnpm
    uv

    # Theme
    nerd-fonts.jetbrains-mono
    adwaita-icon-theme
    shared-mime-info

    # rust
    cargo
    rustc

    # AI
    claude-code
    pi-coding-agent

    # firstmate
    jq
    inputs.treehouse.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.no-mistakes.packages.${pkgs.stdenv.hostPlatform.system}.default

  ];

  # npm: default global prefix is the read-only nodejs store path, so `npm install -g` goes here instead
  home.sessionVariables.NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  home.sessionPath = [ "$HOME/.npm-global/bin" ];

  # Noctalia config
  xdg.configFile."noctalia/settings.json".source = ../../features/noctalia-settings.json;

  # Git config
  programs.git = {
    enable = true;
    settings = {
      user.name = "CWZ Morro";
      user.email = "cwzmorro@gmail.com";
      init.defaultBranch = "main";
    };
  };

  # Jujutsu config
  programs.jujutsu = {
    enable = true;
    settings.user = {
      name = "CWZ Morro";
      email = "cwzmorro@gmail.com";
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

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local config = wezterm.config_builder()
      config.enable_tab_bar = false -- herdr handles tabs
      config.font_size = 14.0
      config.adjust_window_size_when_changing_font_size = false
      return config
    '';
  };

  programs.omp.enable = true;

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    shellWrapperName = "yy";
    settings.mgr = {
      ratio = [ 1 3 4 ];
      sort_by = "natural";
      show_hidden = true;
    };
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
    platformTheme.name = "gtk3";
  };

  programs.home-manager.enable = true;
  # programs.waybar.enable = true;
  services.dunst = {
    enable = true;
    settings.global.follow = "keyboard";
  };

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "auto";
  };

  home.stateVersion = "24.11";
}
