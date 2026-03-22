{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "cielnixazure";
  home.homeDirectory = "/home/cielnixazure";

  home.packages = with pkgs; [
    # GUI Apps
    xwayland-satellite # needed for x11 apps
    discord
    spotify
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Terminal emulator
    kitty

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

    # Runtimes
    nodejs_22
    jdk17
    python3

    # Fonts
    nerd-fonts.jetbrains-mono

  ];

  # Niri config
  xdg.configFile."niri/config.kdl".text = ''
    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "dunst"
    spawn-at-startup "nm-applet"

    window-rule{
      open-maximized true
    }
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


      // Fullscreen and maximize
      Mod+F { maximize-column; }
      Mod+Shift+F { fullscreen-window; }

      // Focus windows
      Mod+H { focus-column-left; }
      Mod+J { focus-window-down; }
      Mod+K { focus-window-up; }
      Mod+L { focus-column-right; }

      // Mmove windows
      Mod+Ctrl+H { move-column-left; }
      Mod+Ctrl+J { move-window-down; }
      Mod+Ctrl+K { move-window-up; }
      Mod+Ctrl+L { move-column-right; }

      // Mouse controls
      Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }
      Mod+WheelScrollRight { focus-column-right; }
      Mod+WheelScrollLeft { focus-column-left; }
    }
  '';

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

  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {

      theme = "catppuccin_mocha";

      editor = {
        # Yanky replacement: Always use system clipboard
        default-yank-register = "+";

        line-number = "relative";
        color-modes = true; # Changes statusline color based on mode (like lualine)

        # Bufferline replacement
        bufferline = "multiple";

        # Cursor shapes like Neovim
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        # UI Improvements
        indent-guides.render = true;
        lsp.display-messages = true;
        lsp.display-inlay-hints = true; # Great for Rust and TypeScript

        # Show hidden files in Telescope-like picker
        file-picker.hidden = false;

        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
            "file-modification-indicator"
          ];
          center = [ "diagnostics" ];
          right = [
            "selections"
            "position"
            "file-encoding"
            "file-type"
            "version-control"
          ];
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };
      };

      # =========================================
      # LAZYVIM KEYBINDING EMULATION
      # =========================================
      keys.normal = {
        # Telescope Equivalents
        space.space = "file_picker"; # <Space><Space> to find files
        space."/" = "global_search"; # <Space>/ to grep
        space.e = "file_explorer"; # Neo-tree equivalent

        # Quick Save/Quit
        space.w = ":w";
        space.q = ":q";

        # Buffer Management (<leader>b...)
        space.b = {
          d = ":buffer-close";
          n = ":buffer-next";
          p = ":buffer-previous";
        };

        # Code Actions (<leader>c...)
        space.c = {
          a = "code_action";
          r = "rename_symbol";
          f = ":format";
        };

        # Neovim Window Navigation (Ctrl + h/j/k/l)
        "C-h" = "jump_view_left";
        "C-j" = "jump_view_down";
        "C-k" = "jump_view_up";
        "C-l" = "jump_view_right";

        # Escape clears selection (Vim-like behavior)
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
      };

      keys.insert = {
        # Standard fast exit from insert mode
        "C-c" = "normal_mode";
      };
    };

    # =========================================
    # LANGUAGE SERVERS & FORMATTERS
    # =========================================
    languages = {
      language-server = {
        basedpyright = {
          command = "basedpyright-langserver";
          args = [ "--stdio" ];
        };
        ruff = {
          command = "ruff";
          args = [ "server" ];
        };
        nixd = {
          command = "nixd";
        };
      };

      language = [
        {
          name = "nix";
          auto-format = true;
          language-servers = [ "nixd" ];
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        }
        {
          name = "python";
          auto-format = true;
          language-servers = [
            "basedpyright"
            "ruff"
          ];
          formatter = {
            command = "${pkgs.ruff}/bin/ruff";
            args = [
              "format"
              "-"
            ];
          };
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = [ "rust-analyzer" ];
          formatter.command = "${pkgs.rustfmt}/bin/rustfmt";
        }
        {
          name = "typescript";
          auto-format = true;
          language-servers = [ "typescript-language-server" ];
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "typescript"
            ];
          };
        }
        {
          name = "tsx";
          auto-format = true;
          language-servers = [
            "typescript-language-server"
            "tailwindcss-ls"
          ];
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "typescript"
            ];
          };
        }
        {
          name = "json";
          auto-format = true;
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "json"
            ];
          };
        }
        {
          name = "markdown";
          auto-format = true;
          language-servers = [ "marksman" ];
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "markdown"
            ];
          };
        }
        {
          name = "lua";
          auto-format = true;
          language-servers = [ "lua-language-server" ];
          formatter = {
            command = "${pkgs.stylua}/bin/stylua";
            args = [ "-" ];
          };
        }
        {
          name = "java";
          language-servers = [ "jdtls" ];
        }
      ];
    };
  };

  programs.home-manager.enable = true;
  # programs.waybar.enable = true;
  services.dunst.enable = true;

  home.stateVersion = "24.11";
}
