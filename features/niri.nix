{ pkgs, ... }:
{
  # Niri config
  xdg.configFile."niri/config.kdl".text = ''
    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "noctalia-shell"
    spawn-at-startup "dunst"
    // spawn-at-startup "nm-applet"

    // Monitor configuration
    output "HDMI-A-1" {
      mode "1920x1080@240"
      position x=0 y=0
      scale 0.9
    }

    output "eDP-1" {
      mode "1920x1080@144"
      position x=-1920 y=0 // To the left of main monitor
      scale 1.0
    }

    layout {
      gaps 8 // Gap between the windows
    }

    window-rule {
    //  open-maximized true
      geometry-corner-radius 12 // Round corner
      clip-to-geometry true
    }

    input {
      keyboard {
        xkb { layout "us"; }
      }

      touchpad {
        natural-scroll
       dwt // Disable while typing
      }
    }

    gestures {
      hot-corners {
        off
      }
    }

    binds {
      Mod+D { spawn "fuzzel"; }
      Mod+Return { spawn "wezterm"; }
      Mod+W { close-window; }
      Mod+O { toggle-overview; }

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
      Mod+J { focus-workspace-down; }
      Mod+K { focus-workspace-up; }
      Mod+L { focus-column-right; }

      // Move windows
      Mod+Ctrl+H { move-column-left; }
      Mod+Ctrl+J { move-window-down; }
      Mod+Ctrl+K { move-window-up; }
      Mod+Ctrl+L { move-column-right; }

      // Focus workspaces
      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }

      // Move workspaces
      Mod+Shift+1 { move-column-to-workspace 1; }
      Mod+Shift+2 { move-column-to-workspace 2; }
      Mod+Shift+3 { move-column-to-workspace 3; }
      Mod+Shift+4 { move-column-to-workspace 4; }
      Mod+Shift+5 { move-column-to-workspace 5; }
      Mod+Shift+6 { move-column-to-workspace 6; }
      Mod+Shift+7 { move-column-to-workspace 7; }
      Mod+Shift+8 { move-column-to-workspace 8; }
      Mod+Shift+9 { move-column-to-workspace 9; }

      // Focus monitors
      Mod+Comma { focus-monitor-left; }
      Mod+Period { focus-monitor-right; }

      // Move windows between monitors
      Mod+Shift+Comma { move-column-to-monitor-left; }
      Mod+Shift+Period { move-column-to-monitor-right; }

      // Mouse controls
      Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }
      Mod+WheelScrollRight { focus-column-right; }
      Mod+WheelScrollLeft { focus-column-left; }
    }
  '';
}
