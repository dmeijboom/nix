{
  lib,
  config,
  ...
}:
{
  programs.alacritty = {
    enable = true;
    theme = "nord";
    settings = {
      env.KONSOLE_VERSION = "230804";
      general.live_config_reload = true;
      mouse.hide_when_typing = true;
      window = {
        decorations = "None";
        startup_mode = "Maximized";
        option_as_alt = "OnlyLeft";
        padding = {
          x = 8;
          y = 8;
        };
      };
      font = {
        size = 14;
        normal.family = "JetBrainsMono Nerd Font";
        bold.family = "JetBrainsMono Nerd Font";
        italic.family = "JetBrainsMono Nerd Font";
        bold_italic.family = "JetBrainsMono Nerd Font";
      };
      cursor.style = {
        shape = "Underline";
        blinking = "Never";
      };
    };
  };
}
