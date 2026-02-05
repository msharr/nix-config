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
      "cleanshot" "raycast" "karabiner-elements" "scroll-reverser" "whatsapp" "eqmac" 

      # development
      "cursor" "ghostty" "visual-studio-code" "docker" 

      # productivity
      "slack" "notion" "protonvpn" "spotify"

      # browsers
     "zen" "google-chrome" "chatgpt" 
    ];
    brews = ["supabase" "awscli"]; 
    taps = [];
    masApps = {
    #  xcode = 497799835;      
    };
  };
}
