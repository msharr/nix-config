{ pkgs, ... }:
{
  programs.aerospace = {
    enable = true;
    
    launchd.enable = true;

    userSettings = {
      "start-at-login" = true;

      "default-root-container-layout" = "tiles";
      "default-root-container-orientation" = "auto";
      "enable-normalization-flatten-containers" = true;
      "enable-normalization-opposite-orientation-for-nested-containers" = true;

      gaps = {
        inner = {
          horizontal = 10;
          vertical = 10;
        };
        outer = {
          left = 10;
          right = 10;
          top = 10;
          bottom = 10;
        };
      };

      mode.main.binding = {
        # Workspace navigation (alt + 1-6)
        "alt-1" = "workspace 1";
        "alt-2" = "workspace 2";
        "alt-3" = "workspace 3";
        "alt-4" = "workspace 4";
        "alt-5" = "workspace 5";
        "alt-6" = "workspace 6";

        # Move window to workspace and follow (alt + shift + 1-6)
        "alt-shift-1" = ["move-node-to-workspace 1" "workspace 1"];
        "alt-shift-2" = ["move-node-to-workspace 2" "workspace 2"];
        "alt-shift-3" = ["move-node-to-workspace 3" "workspace 3"];
        "alt-shift-4" = ["move-node-to-workspace 4" "workspace 4"];
        "alt-shift-5" = ["move-node-to-workspace 5" "workspace 5"];
        "alt-shift-6" = ["move-node-to-workspace 6" "workspace 6"];

        # Focus navigation (Arrow Keys)
        "alt-left" = "focus left";
        "alt-down" = "focus down";
        "alt-up" = "focus up";
        "alt-right" = "focus right";

        # Move windows (Arrow Keys)
        "alt-shift-left" = "move left";
        "alt-shift-down" = "move down";
        "alt-shift-up" = "move up";
        "alt-shift-right" = "move right";

        # Resize windows
        "alt-shift-equal" = "resize smart +50";
        "alt-minus" = "resize smart -50";

        # Fullscreen using Aerospace's native mode
        "alt-f" = "fullscreen";
      };
    };
  };
}
