{
wayland.windowManager.hyprland.enable = true;
wayland.windowManager.hyprland.xwayland.enable = true;
wayland.windowManager.hyprland.settings = {
  "$mod" = "ALT";
  input = {
    kb_layout = "br";
    kb_variant = "thinkpad";

    follow_mouse = 1;
    sensitivity = 0;
    touchpad = {
      natural_scroll = false;
    };
   };
  animations = {
      enabled = true;
      animation = [
        "border, 1, 2, default"
        "fade, 1, 4, default"
        "windows, 1, 3, default, popin 80%"
        "workspaces, 1, 2, default, slide"
      ];
    };

    decoration = {
      rounding = 10;
      blur = {
        enabled = true;
        brightness = 1.0;
        contrast = 1.0;
        noise = 0.01;

        vibrancy = 0.2;
        vibrancy_darkness = 0.5;

        passes = 4;
        size = 7;

        popups = true;
        popups_ignorealpha = 0.2;
      };
      };

  general = {
    layout = "master";

  };

  master = {
   # new_is_master = true;
    no_gaps_when_only = true;

  };
  gestures = {
    workspace_swipe = false; 
  };


  bind =
    [
      # Basic bindings
      "$mod SHIFT, C, killactive"      # Kill active window
#      "$mod, F, exec, librewolf"   # Open Firefox
      "$mod, P, exec, bemenu-run"   # Open Firefox
      "$mod SHIFT, return, exec, alacritty" # Open Alacritty
      "$mod, return, layoutmsg, swapwithmaster"
      "$mod, h, resizeactive, -15 0"
      "$mod, l, resizeactive, 15 0"
      "$mod, f, togglefloating"
      "$mod, m, fullscreen"
      "$mod, mouse:273, movewindow"
#      "$mod, mouse:272, exec, $(hyprctl -j activewindow | jq '.floating') || hyprctl dispatch togglefloating"
      "$mod, mouse:272, exec, hyprctl dispatch movewindowpixel exact $(hyprctl -j cursorpos | jq -r '[.x, .y] | @csv' | tr ',' ' ')"
      ", Print, exec, grimblast copy area"  # Screenshot
    ]
    ++ (
      # Workspaces
      # Bind $mod + [shift +] {1..9} to [move to] workspace {1..9}
      builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        )
        9)
    )
    ++ (
      # dwm-style window management binds
      [
        # Close window (Mod + Shift + Q)
        "$mod SHIFT, Q, killactive"

        # Focus next/previous window (Mod + J/K)
        "$mod, J, cyclenext, next"
        "$mod, K, cyclenext, prev"

             ]
    );

};
}
