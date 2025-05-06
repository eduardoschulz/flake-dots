{
  programs.kitty = {
    enable = true;
    catppuccin.enable = true;
    font = {
      size = 14;
      name = "Meslo LG L";
    };
    settings = {
      background_opacity = 0.9;
      confirm_os_window_close = 0;
      background_blur = 1;
    };
  };

  programs.alacritty = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      window = {
        opacity = 0.9;
        blur = true;
        decorations = "full";
        dynamic_title = true;
      };
      bell = {
        animation = "EaseOutExpo";
        duration = 0;
      };
      font = {
        size = 14;
        normal.family = "Meslo LG L";
        italic.family = "Meslo LG L";
        bold.family = "Meslo LG L";
      };
      mouse = {
        hide_when_typing = true;
      };
    };
  };

}
