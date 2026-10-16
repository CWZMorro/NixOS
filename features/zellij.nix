{ pkgs, inputs, ... }:

{
  programs.zellij = {
    enable = true;

    # Default layout with zellij-load plugin in top-right corner
    # Shows CPU/memory/GPU stats next to tabs in the top bar
    layouts.default = ''
      layout {
        pane size=1 split_direction="vertical" borderless=true {
          pane size="65%" {
            plugin location="tab-bar"
          }
          pane size="35%" {
            plugin location="file:${inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.zellij-load}/share/zellij/plugins/zellij-load.wasm"
          }
        }
        pane
        pane size=2 borderless=true {
          plugin location="status-bar"
        }
      }
    '';

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

}
