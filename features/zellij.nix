{ pkgs, ... }:

let
  # Existing zjstatus plugin for the tabs
  zjstatus = pkgs.fetchurl {
    url = "https://github.com/dj95/zjstatus/releases/download/v0.22.0/zjstatus.wasm";
    sha256 = "sha256-TeQm0gscv4YScuknrutbSdksF/Diu50XP4W/fwFU3VM=";
  };

  # NEW: zellij-load extension for native CPU/RAM monitoring on NixOS
  zellij_load = pkgs.fetchurl {
    url = "https://github.com/christian-prather/zellij-load/releases/latest/download/zellij-load-plugin.wasm";
    # I am using a dummy hash here. Nix will error on the first rebuild and give you the correct one.
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
in
{
  programs.zellij = {
    enable = true;
    settings = {
      # Disables the green pane borders globally
      pane_frames = false;
      default_shell = "fish";
      copy_command = "wl-copy";
      theme = "catppuccin-mocha";

      # Explicit Catppuccin Mocha color definitions
      themes.catppuccin-mocha = {
        bg = "#585b70";
        fg = "#cdd6f4";
        red = "#f38ba8";
        green = "#a6e3a1";
        blue = "#89b4fa";
        yellow = "#f9e2af";
        magenta = "#f5c2e7";
        orange = "#fab387";
        cyan = "#94e2d5";
        black = "#1e1e2e";
        white = "#bac2de";
      };

      keybinds = {
        unbind = [ "Ctrl b" ];
        normal = {
          "bind \"Ctrl s\"" = {
            SwitchToMode = "Tmux";
          };
        };
        tmux = {
          "bind \"h\"" = {
            MoveFocus = "Left";
            SwitchToMode = "Normal";
          };
          "bind \"j\"" = {
            MoveFocus = "Down";
            SwitchToMode = "Normal";
          };
          "bind \"k\"" = {
            MoveFocus = "Up";
            SwitchToMode = "Normal";
          };
          "bind \"l\"" = {
            MoveFocus = "Right";
            SwitchToMode = "Normal";
          };
          "bind \"v\"" = {
            SwitchToMode = "Scroll";
          };
        };
        # Footer left exactly as requested
        scroll = {
          "bind \"v\"" = {
            Write = [ 118 ];
          };
          "bind \"y\"" = {
            Copy = "System";
            SwitchToMode = "Normal";
          };
        };
      };
    };
  };

  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
        # Split the top bar horizontally to house both plugins side-by-side
        pane size=1 borderless=true split_direction="vertical" {
            
            # LEFT SIDE: zjstatus (Tabs only, no session name)
            pane borderless=true {
                plugin location="file:${zjstatus}" {
                    format_left  "{tabs}"
                    format_right ""
                    format_space "#[bg=default]"

                    # Right-facing arrows () with new Catppuccin colors
                    tab_normal   "#[bg=#89b4fa,fg=#1e1e2e,bold]  {index} #[bg=default,fg=#89b4fa] "
                    tab_active   "#[bg=#a6e3a1,fg=#1e1e2e,bold]  {index} #[bg=default,fg=#a6e3a1] "
                }
            }
            
            # RIGHT SIDE: zellij-load (Hardware stats)
            pane size=35 borderless=true {
                plugin location="file:${zellij_load}" {
                    theme "catppuccin-mocha"
                }
            }
        }
        
        # Main working area
        pane
    }
  '';
}
