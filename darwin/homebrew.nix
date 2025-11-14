{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };

    caskArgs.no_quarantine = true;
    global.brewfile = true;

    casks = [
      # utilities
      "cleanshot" "raycast" "karabiner-elements" "scroll-reverser"

      # development
      "cursor" "ghostty"

      # productivity
      "slack" "notion" "1password" "protonvpn"

      # browsers
      "google-chrome" "zen" "chatgpt"
    ];
    brews = []; 
    taps = [];
  };
}
