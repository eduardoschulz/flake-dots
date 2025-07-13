{
    programs.rofi = {
        enable = true;
#        theme = builtins.readFile ./catppuccin.rasi;
        configPath = "./config.rasi";

    };

    catppuccin.rofi.enable = true;

}
