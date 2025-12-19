{
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
      keyboard.bindings = [
        {
          key = "Left";
          mods = "Alt";
          chars = "\\u001Bb";
        }
        {
          key = "Right";
          mods = "Alt";
          chars = "\\u001Bf";
        }
      ];
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
        size = 13;
        normal.family = "MonaspiceAr Nerd Font Mono";
        bold.family = "MonaspiceAr Nerd Font Mono";
        italic.family = "MonaspiceAr Nerd Font Mono";
        bold_italic.family = "MonaspiceAr Nerd Font Mono";
      };
      cursor.style = {
        shape = "Underline";
        blinking = "Never";
      };
    };
  };
}
