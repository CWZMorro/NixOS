{ config, pkgs, inputs, ... }:

{
  imports = [ inputs.nixCats.homeModule ];

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
    ripgrep
    fd
    unzip
    gcc
    lazygit

    # Runtimes
    nodejs_22
    jdk17
    python3

    # LSP & formatters
    nixd
    nixfmt-rfc-style
    lua-language-server
    stylua
    vtsls
    basedpyright
    ruff

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

      // Brightness controls
      Mod+XF86AudioRaiseVolume allow-when-locked=true { spawn "brightnessctl" "set" "5%+"; }
      Mod+XF86AudioLowerVolume allow-when-locked=true { spawn "brightnessctl" "set" "5%-"; }
      // Screenshot
      Print { spawn "sh" "-c" "grim -g \"$(slurp)\" - | wl-copy";}
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
      conf = "nvim ~/nixos-config/hosts/local/configuration.nix";
      home = "nvim ~/nixos-config/home/cielnixazure/home.nix";
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

  # Nixcats config
  nixCats = {
    enable = true;
    packageNames = [ "nvim" ];
    luaPath = ../../nvim;
    categoryDefinitions.replace = ({ pkgs, ...}: {
      startupPlugins = {
        general = with pkgs.vimPlugins; [
          # Core framework & manager
          LazyVim
          lazy-nvim # plugin manager

          # UI
          snacks-nvim
          noice-nvim
          lualine-nvim
          bufferline-nvim
          gitsigns-nvim
          mini-icons
          which-key-nvim
          todo-comments-nvim
          trouble-nvim
          nui-nvim

          # Completion & snippets
          blink-cmp
          blink-compat
          friendly-snippets

          # Editing & navigation
          flash-nvim
          mini-ai
          mini-pairs
          grug-far-nvim
          yanky-nvim
          persistence-nvim
          plenary-nvim

          # LSP, formatting & linting
          nvim-lspconfig
          conform-nvim
          nvim-lint
          lazydev-nvim
          SchemaStore-nvim

          # Treesitter
          nvim-treesitter.withAllGrammars
          nvim-treesitter-textobjects
          nvim-ts-autotag
          ts-comments-nvim

          # Colorscheme
          tokyonight-nvim
          catppuccin-nvim
          
          # Mason
          mason-nvim
          mason-lspconfig-nvim
          
          # Misc
          nvim-jdtls # extended support for java
          venv-selector-nvim # venvs selector
          markdown-preview-nvim 
          render-markdown-nvim
        ];
      };
    });
    packageDefinitions.replace  = {
      nvim = ({ pkgs, ... }: {
        categories = {
          general = true;
        };
      });
    };
  };

  programs.home-manager.enable = true;
  programs.waybar.enable = true;
  services.dunst.enable = true;

  home.stateVersion = "24.11";
}
