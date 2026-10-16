{ pkgs, ... }:

{
  # Terminal multiplexer for coding agents (replaces zellij)
  home.packages = [ pkgs.herdr ];

  # Read-only once managed here: change settings in this file, not in herdr's settings screen
  xdg.configFile."herdr/config.toml".text = ''
    # First-run setup writes to this file, which home-manager owns
    onboarding = false

    [terminal]
    default_shell = "fish"

    [keys]
    # Same prefix as the old zellij tmux mode; prefix + h/j/k/l moves between panes
    prefix = "ctrl+s"
  '';
}
