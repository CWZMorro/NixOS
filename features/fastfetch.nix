{ pkgs, ... }:

{
  programs.fastfetch.enable = true;

  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "type": "builtin",
        "padding": {
          "top": 3,
          "left": 2
        }
      },
      "modules": [
        "break",
        "title",
        "separator",
        { "type": "host", "key": " PC   ", "keyColor": "green" },
        { "type": "os", "key": "│ ├OS  ", "keyColor": "green" },
        { "type": "cpu", "key": "│ ├CPU ", "keyColor": "green" },
        { "type": "gpu", "key": "│ ├GPU ", "keyColor": "green" },
        { "type": "memory", "key": "│ ├MEM ", "keyColor": "green" },
        { "type": "disk", "key": "└ └DISK", "keyColor": "green" },
        { "type": "kernel", "key": " Kernal  ", "keyColor": "yellow" },
        { "type": "display", "key": "│ ├DISPLAY", "keyColor": "yellow" },
        { "type": "bios", "key": "│ ├BIOS   ", "keyColor": "yellow" },
        { "type": "de", "key": "│ ├WM     ", "keyColor": "yellow" },
        { "type": "lm", "key": "└ └LM     ", "keyColor": "yellow" },
        { "type": "shell", "key": " Shell    ", "keyColor": "blue" },
        { "type": "terminal", "key": "│ ├Terminal", "keyColor": "blue" },
        { "type": "packages", "key": "│ ├Packages", "keyColor": "blue" },
        { "type": "terminalfont", "key": "│ ├Font    ", "keyColor": "blue" },
        { "type": "cursor", "key": "└ └Cursor  ", "keyColor": "blue" },
        {
          "type": "command",
          "key": "OS Age  ",
          "keyColor": "magenta",
          "text": "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days"
        },
        { "type": "uptime", "key": "Uptime  ", "keyColor": "magenta" },
        { "type": "datetime", "key": "DateTime", "keyColor": "magenta" },
        { "type": "locale", "key": "Locale  ", "keyColor": "magenta" },
        {
          "type": "colors",
          "paddingLeft": 2,
          "symbol": "circle"
        }
      ]
    }
  '';

  # Minimal config
  xdg.configFile."fastfetch/minimal.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "type": "kitty",
        "source": "~/.config/fastfetch/MorroPfp.png",
        "width": 18,
        "padding": {
          "top": 2,
          "left": 2,
          "right": 2
        }
      },
      "display": {
        "separator": " "
      },
      "modules": [
        { "type": "custom", "key": "{##626880}╭────────────╮{#}", "format": " " },
        { "type": "title", "key": "{##626880}│ {##e78284} user     {##626880}│{#}", "format": "Ciel Nix Azure ({user-name})" },
        { "type": "host", "key": "{##626880}│ {##ef9f76}󰋜 host     {##626880}│{#}" },
        { "type": "os", "key": "{##626880}│ {##a6d189}󰣇 distro   {##626880}│{#}" },
        { "type": "kernel", "key": "{##626880}│ {##81c8be}󰒋 kernel   {##626880}│{#}" },
        { "type": "terminal", "key": "{##626880}│ {##99d1db}󰆍 term     {##626880}│{#}" },
        { "type": "shell", "key": "{##626880}│ {##8caaee}󰞷 shell    {##626880}│{#}" },
        { "type": "cpu", "key": "{##626880}│ {##babbf1} cpu      {##626880}│{#}" },
        { "type": "disk", "key": "{##626880}│ {##ca9ee6}󰋊 disk     {##626880}│{#}" },
        { "type": "memory", "key": "{##626880}│ {##f4b8e4}󰍛 memory   {##626880}│{#}" },
        { "type": "custom", "key": "{##626880}╰────────────╯{#}", "format": " " }
      ]
    }
  '';

  xdg.configFile."fastfetch/MorroPfp.png".source = ../media/roundprofile.png;
}
