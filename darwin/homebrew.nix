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
      "cursor" "ghostty" "visual-studio-code" "docker-desktop" "session-manager-plugin" "claude-code"

      # productivity
      "slack" "notion" "protonvpn" "spotify" "postman" "linear-linear"

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
