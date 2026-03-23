{ pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "fish";
      mouse_mode = true;
      copy_command = "wl-copy";
      show_startup_tips = false;

      theme = "catppuccin-mocha";
      themes.catppuccin-mocha = {
        bg = "#585b70";
        fg = "#cdd6f4";
        red = "#f38ba8";
        green = "#a6e22e";
        blue = "#89b4fa";
        yellow = "#f9e2af";
        magenta = "#f5c2e7";
        orange = "#fab387";
        teal = "#94e2d5";
        crust = "#1e1e2e";
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
        scroll = {
          "bind \"v\"" = {
            Write = [ 118 ];
          };
          "bind \"y\"" = {
            Copy = { };
            SwitchToMode = "Normal";
          };
        };
      };
    };
  };
}
