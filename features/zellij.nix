{ pkgs, ... }:

let
  zjstatus = pkgs.fetchurl {
    url = "https://github.com/dj95/zjstatus/releases/download/v0.22.0/zjstatus.wasm";
    sha256 = "sha256-TeQm0gscv4YScuknrutbSdksF/Diu50XP4W/fwFU3VM=";
  };

  zellij_load = pkgs.fetchurl {
    url = "https://github.com/christian-prather/zellij-load/releases/latest/download/zellij-load-plugin.wasm";
    sha256 = "sha256-8oMVDV0edKjXMQSa10zJRwIlunWkJVnOBvzv5KlS6fQ=";
  };
in
{
  programs.zellij = {
    enable = true;
    settings = {
      pane_frames = false;
      default_shell = "fish";
      copy_command = "wl-copy";
      theme = "catppuccin-mocha";
      show_startup_tips = false;

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
      };
    };
  };

  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
        // TOP BAR: Split vertically to hold both plugins
        pane size=1 split_direction="vertical" {
            
            // Top Left: ONLY the tabs (No name, no title)
            pane {
                plugin location="file:${zjstatus}" {
                    format_left  "{tabs}"
                    format_right ""
                    format_space "#[bg=default]"

                    tab_normal   "#[bg=#89b4fa,fg=#1e1e2e,bold]  {index} #[bg=default,fg=#89b4fa] "
                    tab_active   "#[bg=#a6e3a1,fg=#1e1e2e,bold]  {index} #[bg=default,fg=#a6e3a1] "
                }
            }
            
            // Top Right: CPU and RAM tracking
            pane size=35 {
                plugin location="file:${zellij_load}" {
                    theme "catppuccin-mocha"
                }
            }
        }
        
        // MAIN TERMINAL AREA
        pane
        
        // BOTTOM BAR: Restoring the section I accidentally deleted
        pane size=2 {
            plugin location="zellij:status-bar"
        }
    }
  '';
}
