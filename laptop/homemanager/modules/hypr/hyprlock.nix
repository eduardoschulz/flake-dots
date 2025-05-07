{
    programs.hyprlock = {
        enable = true;
        settings = { 
            general = {
            disable_loading_bar = true;
            grace = 0;
            hide_cursor = false;
            no_fade_in = true;
            no_fade_out = true;
        };
        backgroud = [{

            path = "/home/eduardo/Pictures/Wallpapers/moon.png";
                blur_passes = 2;
                contrast = 1;
                brightness = 0.5;
                vibrancy = 0.2;
                vibrancy_darkness = 0.2;

        }];

 input-field = [
    {
      size = "200, 50";
      position = "0, -80";
      monitor = "";
      dots_center = true;
      fade_on_empty = false;
      font_color = "rgb(202, 211, 245)";
      inner_color = "rgb(91, 96, 120)";
      outer_color = "rgb(24, 25, 38)";
      outline_thickness = 5;
      #placeholder_text = '\'Password...'\';
      shadow_passes = 2;
    }
  ];






    };

};
}
