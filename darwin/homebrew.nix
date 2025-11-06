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
      "cleanshot"
      "raycast"
      "karabiner-elements"

      "cursor"
      "ghostty"

      "slack"
      "notion"

      "1password"
      "protonvpn"
      "google-chrome"
      "zen"

      "chatgpt"
    ];
    brews = []; 
    taps = [];
  };
}
