{ pkgs, ... }:

{
  home.packages = [ pkgs.herdr ];

  xdg.configFile."herdr/config.toml".text = ''
    onboarding = false

    [terminal]
    default_shell = "fish"

    [keys]
    prefix = "ctrl+s"
    split_vertical = "prefix+%"
    split_horizontal = "prefix+\""

    [experimental]
    pane_history = true
  '';
}
